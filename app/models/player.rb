class Player < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :player_tournaments, dependent: :destroy
  has_many :tournaments, through: :player_tournaments

end
