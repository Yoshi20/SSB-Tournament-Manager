class Tournament < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations

  validates :name, uniqueness: true

  MAX_PAST_TOURNAMENTS_PER_PAGE = 10

  def canceled?
    !self.started and self.finished
  end

  def is_past?
    self.date < Time.now
  end

end
