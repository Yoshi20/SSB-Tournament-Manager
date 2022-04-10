class Team < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :players

  validates :name_long, :name_short, uniqueness: true, presence: true
  validates :name_short, length: { maximum: 12 }

  scope :all_from, ->(country_code) { where(country_code: country_code) }

end
