class Player < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :tournaments, through: :registrations

end
