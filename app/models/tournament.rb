class Tournament < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations

  validates :name, uniqueness: true

  scope :for_calendar, -> { where(active: true).where('date > ? and date < ?', 2.weeks.ago, Date.today + 4.months) }

  MAX_PAST_TOURNAMENTS_PER_PAGE = 10

  def canceled?
    !self.started and self.finished
  end

  def is_past?
    self.date < Time.now
  end

end
