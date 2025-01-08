class Tournament < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations
  has_many :matches, dependent: :destroy
  has_many :results, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  scope :all_from, ->(country_code) { where(country_code: country_code) }
  scope :active, -> { where(active: true) }
  scope :upcoming, -> { where('date > ?', Time.zone.now) }
  scope :upcoming_with_today, -> { where('date >= ?', Time.zone.now.beginning_of_day) }
  scope :ongoing, -> { where('(finished IS FALSE OR finished IS NULL) AND date <= ? AND date >= ?', Time.zone.now, Time.zone.now - 6.hours) }
  scope :past, -> { where('started AND finished OR date < ?', Time.zone.now - 6.hours) }
  scope :for_calendar, -> { where(active: true).where('date > ? AND date < ?', 2.weeks.ago, Date.today + 4.months) }
  scope :from_city, -> (city) { where("name ILIKE ? OR name ILIKE ? OR location ILIKE ? OR location ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(city)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city.downcase)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city.downcase)}%") }

  before_create :set_region

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
    (!self.started && self.finished)
  end

  def ongoing?
    (!self.finished && self.date <= Time.zone.now && self.date >= (Time.zone.now - 6.hours))
  end

  def is_past?
    (self.date < Time.zone.now)
  end

  def has_pools?
    (self.number_of_pools.to_i > 0)
  end

  def weekly?
    (self.subtype == 'weekly')
  end

  def internal?
    (self.subtype == 'internal')
  end

  def external?
    (self.subtype == 'external')
  end

  def external_weekly?
    (self.subtype == 'external' && self.name.downcase.include?('weekly'))
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

  def set_region
    return if self.region.present?
    # handle special case: "Iceland"
    if self.country_code == 'is'
      self.region = 'iceland'  # Iceland has only one region
      return
    end
    regions_raw = ApplicationController.helpers.regions_raw_from(self.country_code)
    regions_de = ['ch', 'de'].include?(self.country_code) ? I18n.t(regions_raw, scope: 'defines.regions', locale: :de).map(&:downcase) : []
    regions_fr = ['ch', 'fr'].include?(self.country_code) ? I18n.t(regions_raw, scope: 'defines.regions', locale: :fr).map(&:downcase) : []
    regions_en = ['ch', 'de', 'fr', 'lu', 'it', 'uk', 'pt', 'is', 'us_ca'].include?(self.country_code) ? I18n.t(regions_raw, scope: 'defines.regions', locale: :en).map(&:downcase) : []
    regions_it = ['it'].include?(self.country_code) ? I18n.t(regions_raw, scope: 'defines.regions', locale: :it).map(&:downcase) : []
    regions_pt = ['pt'].include?(self.country_code) ? I18n.t(regions_raw, scope: 'defines.regions', locale: :pt).map(&:downcase) : []
    regions_is = ['is'].include?(self.country_code) ? I18n.t(regions_raw, scope: 'defines.regions', locale: :is).map(&:downcase) : []
    # First: Try to determine region from city
    if self.city.present?
      city = self.city.downcase
      #city = city.gsub('basel', 'basel-stadt').gsub('bâle', 'bâle-ville').gsub('gallen', 'st. gallen')
      if (regions_de.include?(city) || regions_fr.include?(city) || regions_en.include?(city) || regions_it.include?(city) || regions_pt.include?(city) || regions_is.include?(city))
        self.region = regions_raw[regions_de.index(city)] if regions_de.index(city).present?
        self.region = regions_raw[regions_fr.index(city)] if regions_fr.index(city).present?
        self.region = regions_raw[regions_en.index(city)] if regions_en.index(city).present?
        self.region = regions_raw[regions_it.index(city)] if regions_it.index(city).present?
        self.region = regions_raw[regions_pt.index(city)] if regions_pt.index(city).present?
        self.region = regions_raw[regions_is.index(city)] if regions_is.index(city).present?
        return # as soon as region was found
      end
    end
    # Second: Try to determine region from a word in location
    if self.location.present?
      self.location.downcase.split(' ').each do |l|
        l = l.gsub(',', '')#.gsub('basel', 'basel-stadt').gsub('bâle', 'bâle-ville').gsub('gallen', 'st. gallen')
        if (regions_de.include?(l) || regions_fr.include?(l) || regions_en.include?(l) || regions_it.include?(l) || regions_pt.include?(l) || regions_is.include?(l))
          self.region = regions_raw[regions_de.index(l)] if regions_de.index(l).present?
          self.region = regions_raw[regions_fr.index(l)] if regions_fr.index(l).present?
          self.region = regions_raw[regions_en.index(l)] if regions_en.index(l).present?
          self.region = regions_raw[regions_it.index(l)] if regions_it.index(l).present?
          self.region = regions_raw[regions_pt.index(l)] if regions_pt.index(l).present?
          self.region = regions_raw[regions_is.index(l)] if regions_is.index(l).present?
          return # as soon as region was found
        end
      end
      # Third: Try to find the region with the help of Google Maps
      require 'open-uri'
      require 'json'
      begin
        country = self.country_code.include?('us_') ? 'US' : self.country_code.upcase
        url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{ERB::Util.url_encode(self.location)}&components=country:#{country}&key=#{ENV['GOOGLE_MAPS_SERVER_SIDE_API_KEY']}&outputFormat=json"
        json_data = JSON.parse(URI.open(url).read)
        if json_data["status"] == "OK" && json_data["results"].present? && json_data["results"][0].present?
          json_data["results"][0]["address_components"].each do |res|
            if (res["types"].present? && res["types"].include?('administrative_area_level_1'))
              if res["long_name"].present?
                sn = res["short_name"]
                # handle special case: "England"
                if sn == "England"
                  json_data["results"][0]["address_components"].each do |res|
                    if (res["types"].present? && res["types"].include?('administrative_area_level_2'))
                      sn2 = res["short_name"]
                      uk_region = ApplicationController.helpers.counties_of_england[sn2.to_sym] if sn2.present?
                      if regions_raw.include?(uk_region)
                        self.region = uk_region
                        return # as soon as region was found
                      end
                    end
                  end
                end
                # handle special case: "California"
                if sn == "CA"
                  json_data["results"][0]["address_components"].each do |res|
                    if (res["types"].present? && res["types"].include?('administrative_area_level_2'))
                      sn2 = res["short_name"]
                      us_ca_region = ApplicationController.helpers.counties_of_us_ca[sn2.to_sym] if sn2.present?
                      if regions_raw.include?(us_ca_region)
                        self.region = us_ca_region
                        return # as soon as region was found
                      end
                    end
                  end
                end
                # handle normal case
                if regions_raw.include?(sn)
                  self.region = sn
                  return # as soon as region was found
                end
                ln = res["long_name"].downcase  # long_name will most likely never be necessary
                if (regions_de.include?(ln) || regions_fr.include?(ln) || regions_en.include?(ln) || regions_it.include?(ln) || regions_pt.include?(ln) || regions_is.include?(ln))
                  self.region = regions_raw[regions_de.index(ln)] if regions_de.index(ln).present?
                  self.region = regions_raw[regions_fr.index(ln)] if regions_fr.index(ln).present?
                  self.region = regions_raw[regions_en.index(ln)] if regions_en.index(ln).present?
                  self.region = regions_raw[regions_it.index(ln)] if regions_it.index(ln).present?
                  self.region = regions_raw[regions_pt.index(ln)] if regions_pt.index(ln).present?
                  self.region = regions_raw[regions_is.index(ln)] if regions_is.index(ln).present?
                  return # as soon as region was found
                end
              end
            end
          end
        end
        # send email if region still empty
        unless self.region.present?
          #blup: TODO -> send email if region still empty
        end
      rescue OpenURI::HTTPError => ex
        puts ex
      end
    end
  end

end
