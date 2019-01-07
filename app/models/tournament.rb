class Tournament < ApplicationRecord
  has_many :player_tournaments, dependent: :destroy
  has_many :players, through: :player_tournaments

end
