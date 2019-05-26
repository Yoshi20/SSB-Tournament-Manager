class Match < ApplicationRecord
  belongs_to :tournament

  def player1
    Player.find(self.player1_id)
  end

  def player2
    Player.find(self.player2_id)
  end

end
