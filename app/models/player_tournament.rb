class PlayerTournament < ApplicationRecord
  belongs_to :player
  belongs_to :tournament

end
