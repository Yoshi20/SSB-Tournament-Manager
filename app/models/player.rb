class Player < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :tournaments, through: :registrations

  before_validation :strip_whitespace

  validates :gamer_tag, :presence => true

  def strip_whitespace
    self.gamer_tag.try(:strip!)
  end

  def update_tournament_experience
    if self.participations == 0
      self.tournament_experience = 0 if self.tournament_experience < 0 # None
    elsif self.participations < 5
      self.tournament_experience = 1 if self.tournament_experience < 1 # A little
    elsif self.participations < 10
      self.tournament_experience = 2 if self.tournament_experience < 2 # Some
    elsif self.participations < 30
      self.tournament_experience = 3 if self.tournament_experience < 3 # A lot
    else
      self.tournament_experience = 4 if self.tournament_experience < 4 # Very much
    end
    self.save
  end
end
