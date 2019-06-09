class Tournament < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations
  has_many :matches, dependent: :destroy
  has_many :results, dependent: :destroy

  validates :name, uniqueness: true

  scope :active_2019, -> { where(active: true).where('date > ? AND date < ?', Time.local(2019,1,1), Time.local(2019,12,31,23,59,59)) }
  scope :upcoming, -> { where('date > ?', Time.now) }
  scope :ongoing, -> { where('date <= ? AND date >= ?', Time.now, Time.now - 6.hours) }
  scope :past, -> { where('date < ?', Time.now - 6.hours) }
  scope :for_calendar, -> { where(active: true).where('date > ? AND date < ?', 2.weeks.ago, Date.today + 4.months) }
  scope :from_city, -> (city) { where("name LIKE ? OR name LIKE ? OR location LIKE ? OR location LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(city)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city.downcase)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city.downcase)}%") }

  MAX_PAST_TOURNAMENTS_PER_PAGE = 10

  def cancelled?
    !self.started and self.finished
  end

  def is_past?
    self.date < Time.now
  end

  def game_stations_count
    gs_count = 0
    self.registrations.where('game_stations is not NULL').each do |r|
      gs_count += r.game_stations
    end
    gs_count
  end

end
