class Tournament < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations

  validates :name, uniqueness: true

  MAX_PAST_TOURNAMENTS_PER_PAGE = 10

end
