class Player < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :tournaments, through: :registrations

  def update_tournament_experience
    if self.participations >= 30 and self.tournament_experience < 2 then self.tournament_experience = 2
    elsif self.participations >= 10 and self.tournament_experience < 1 then self.tournament_experience = 1
    end
    self.save
  end
end
