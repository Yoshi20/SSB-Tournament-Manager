class Player < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :tournaments, through: :registrations

  before_validation :strip_whitespace

  validates :gamer_tag, :presence => true

  def results_sum(city_or_major)
    points = 0
    participations = 0
    wins = 0
    losses = 0
    self.results.each do |r|
      if city_or_major.capitalize == r.city or (r.major_name.present? and r.major_name.include?(city_or_major))
        points += r.points
        participations += 1
        wins += r.wins
        losses += r.losses
      end
    end
    if wins == 0 and losses == 0
      return [points, participations, nil]
    else
      return [points, participations, wins.to_f/(wins+losses)]
    end
  end

  def matches
    Match.where(player1_id: self.id).or(Match.where(player2_id: self.id))
  end

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
