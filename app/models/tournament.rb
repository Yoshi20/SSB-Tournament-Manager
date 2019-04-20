class Tournament < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations

  validates :name, uniqueness: true

  scope :active_2019, -> { where(active: true).where('date > ? AND date < ?', Time.local(2019,1,1), Time.local(2019,12,31,23,59,59)) }
  scope :upcoming, -> { where('date >= ?', Time.now) }
  scope :past, -> { where('date < ?', Date.today) }
  scope :for_calendar, -> { where(active: true).where('date > ? AND date < ?', 2.weeks.ago, Date.today + 4.months) }
  scope :from_city, -> (city) { where("name like ? OR name like ? OR location like ? OR location like ?", "%#{city}%", "%#{city.downcase}%", "%#{city}%", "%#{city.downcase}%") }

  MAX_PAST_TOURNAMENTS_PER_PAGE = 10

  def cancelled?
    !self.started and self.finished
  end

  def is_past?
    self.date < Time.now
  end

end
