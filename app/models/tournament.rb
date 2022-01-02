class Tournament < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations
  has_many :matches, dependent: :destroy
  has_many :results, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  scope :active, -> { where(active: true) }
  scope :upcoming, -> { where('date > ?', Time.now) }
  scope :ongoing, -> { where('(finished IS FALSE OR finished IS NULL) AND date <= ? AND date >= ?', Time.now, Time.now - 6.hours) }
  scope :past, -> { where('started AND finished OR date < ?', Time.now - 6.hours) }
  scope :for_calendar, -> { where(active: true).where('date > ? AND date < ?', 2.weeks.ago, Date.today + 4.months) }
  scope :from_city, -> (city) { where("name ILIKE ? OR name ILIKE ? OR location ILIKE ? OR location ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(city)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city.downcase)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city.downcase)}%") }

  before_create :set_canton

  MAX_PAST_TOURNAMENTS_PER_PAGE = 20

  def self.search(search)
    if search
      sanitizedSearch = ActiveRecord::Base.sanitize_sql_like(search)
      # name location city ranking_string
      where("name ILIKE ? or location ILIKE ? or city ILIKE ?", "%#{sanitizedSearch}%", "%#{sanitizedSearch}%", "%#{sanitizedSearch}%")
    else
      :all
    end
  end

  def cancelled?
    !self.started and self.finished
  end

  def is_past?
    self.date < Time.now
  end

  def has_pools?
    self.number_of_pools.to_i > 0
  end

  def weekly?
    self.subtype == 'weekly'
  end

  def game_stations_count
    gs_count = 0
    self.registrations.where('game_stations is not NULL').each do |r|
      gs_count += r.game_stations
    end
    gs_count
  end

  def host
    User.find_by(username: self.host_username) if self.host_username.present?
  end

  def set_canton
    return if self.canton.present?
    cantons_raw = ApplicationController.helpers.cantons_raw
    cantons_de = I18n.t(cantons_raw, scope: 'defines.cantons', locale: :de).map(&:downcase)
    cantons_fr = I18n.t(cantons_raw, scope: 'defines.cantons', locale: :fr).map(&:downcase)
    cantons_en = I18n.t(cantons_raw, scope: 'defines.cantons', locale: :en).map(&:downcase)
    # First: Try to determine canton from city
    if self.city.present?
      city = self.city.downcase
      city = city.gsub('basel', 'basel-stadt').gsub('bâle', 'bâle-ville').gsub('gallen', 'st. gallen')
      if (cantons_de.include?(city) || cantons_fr.include?(city) || cantons_en.include?(city))
        self.canton = cantons_raw[cantons_de.index(city)] if cantons_de.index(city).present?
        self.canton = cantons_raw[cantons_fr.index(city)] if cantons_fr.index(city).present?
        self.canton = cantons_raw[cantons_en.index(city)] if cantons_en.index(city).present?
        return # as soon as canton was found
      end
    end
    # Second: Try to determine canton from a word in location
    if self.location.present?
      self.location.downcase.split(' ').each do |l|
        l = l.gsub(',', '').gsub('basel', 'basel-stadt').gsub('bâle', 'bâle-ville').gsub('gallen', 'st. gallen')
        if (cantons_de.include?(l) || cantons_fr.include?(l) || cantons_en.include?(l))
          self.canton = cantons_raw[cantons_de.index(l)] if cantons_de.index(l).present?
          self.canton = cantons_raw[cantons_fr.index(l)] if cantons_fr.index(l).present?
          self.canton = cantons_raw[cantons_en.index(l)] if cantons_en.index(l).present?
          return # as soon as canton was found
        end
      end
      # Third: Try to find the canton with the help of Google Maps
      require 'open-uri'
      require 'json'
      begin
        json_data = JSON.parse(URI.open("https://maps.googleapis.com/maps/api/geocode/json?address=#{ERB::Util.url_encode(self.location)}&components=country:CH&key=#{ENV['GOOGLE_MAPS_API_KEY']}&outputFormat=json").read)
        if json_data["status"] == "OK" && json_data["results"].present? && json_data["results"][0].present?
          json_data["results"][0]["address_components"].each do |res|
            if (res["types"].present? && res["types"].include?('administrative_area_level_1'))
              if res["long_name"].present?
                ln = res["long_name"].downcase
                if (cantons_de.include?(ln) || cantons_fr.include?(ln) || cantons_en.include?(ln))
                  self.canton = cantons_raw[cantons_de.index(ln)] if cantons_de.index(ln).present?
                  self.canton = cantons_raw[cantons_fr.index(ln)] if cantons_fr.index(ln).present?
                  self.canton = cantons_raw[cantons_en.index(ln)] if cantons_en.index(ln).present?
                  return # as soon as canton was found
                end
              end
            end
          end
        end
      rescue OpenURI::HTTPError => ex
        puts ex
      end
    end
  end

end
