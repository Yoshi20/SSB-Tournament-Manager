class Player < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :alternative_gamer_tags, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :tournaments, through: :registrations
  has_and_belongs_to_many :teams

  acts_as_taggable_on :roles if ActiveRecord::Base.connection.table_exists?('tags')

  before_validation :strip_whitespace
  after_save :delete_identical_alt

  validates :gamer_tag, uniqueness: true, presence: true
  validate :validate_gamer_tag_is_truly_uniq
  validates :prefix, length: { maximum: 12 }

  scope :all_from, ->(country_code) { where(country_code: country_code) }
  scope :from_2019, -> { where('created_at >= ? AND created_at < ?', Time.zone.local(2019,1,1), Time.zone.local(2020,1,1)) }
  scope :from_2020, -> { where('created_at >= ? AND created_at < ?', Time.zone.local(2020,1,1), Time.zone.local(2021,1,1)) }
  scope :from_2021, -> { where('created_at >= ? AND created_at < ?', Time.zone.local(2021,1,1), Time.zone.local(2022,1,1)) }
  scope :from_2022, -> { where('created_at >= ? AND created_at < ?', Time.zone.local(2022,1,1), Time.zone.local(2023,1,1)) }
  scope :from_2023, -> { where('created_at >= ? AND created_at < ?', Time.zone.local(2023,1,1), Time.zone.local(2024,1,1)) }
  scope :from_2024, -> { where('created_at >= ? AND created_at < ?', Time.zone.local(2024,1,1), Time.zone.local(2025,1,1)) }
  scope :from_2025, -> { where('created_at >= ? AND created_at < ?', Time.zone.local(2025,1,1), Time.zone.local(2026,1,1)) }

  MAX_PLAYERS_PER_PAGE = 50
  MAX_PLAYER_VIDEOS_PER_PAGE = 5

  def delete_identical_alt
    self.alternative_gamer_tags.each do |agt|
      agt.delete if agt.gamer_tag == self.gamer_tag
    end
  end

  def validate_gamer_tag_is_truly_uniq
    if AlternativeGamerTag.all_from(self.country_code).exists?(gamer_tag: self.gamer_tag) && self.alternative_gamer_tags.find_by(gamer_tag: self.gamer_tag).nil?
      errors.add(:gamer_tag, I18n.t('not_uniq'))
    end
  end

  def self.search(search)
    if search
      sanitizedSearch = ActiveRecord::Base.sanitize_sql_like(search)
      where("gamer_tag ~* '.*" + ApplicationController.helpers.unaccent(sanitizedSearch) + ".*'").or(where(  # ~* is the case-insensitive regexp operator
        "prefix ~* '.*" + ApplicationController.helpers.unaccent(sanitizedSearch) + ".*'"
      ))
    else
      :all
    end
  end

  def self.iLikeSearch(search)
    if search
      sanitizedSearch = ActiveRecord::Base.sanitize_sql_like(search)
      where("gamer_tag ILIKE ? or prefix ILIKE ?", "%#{sanitizedSearch}%", "%#{sanitizedSearch}%")
    else
      :all
    end
  end

  def win_loss_ratio
    if self.wins == 0 and self.losses == 0
      return 0
    else
      return (self.wins.to_f/(self.wins+self.losses)*100).round(2)
    end
  end

  def seed_points
    seed_points = (self.participations == 0 ? 0 : self.points.to_f/self.participations)
    seed_points += self.win_loss_ratio
    seed_points += self.participations
    seed_points += self.self_assessment.to_f/5
    seed_points += self.tournament_experience.to_f/10
    return seed_points
  end

  def results_sum(city_or_major)
    points = 0
    participations = 0
    wins = 0
    losses = 0
    self.results.each do |r|
      if city_or_major.capitalize == r.city or (r.major_name.present? and r.major_name.downcase.include?(city_or_major.downcase))
        points += r.points
        participations += 1
        wins += r.wins
        losses += r.losses
      end
    end
    if wins == 0 and losses == 0
      return [points, -participations, 0]
    else
      return [points, -participations, (wins.to_f/(wins+losses)*100).round(2)]
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

  def sanitized_youtube_video_ids
    self.youtube_video_ids.gsub('https://youtu.be/', '').gsub('https://www.youtube.com/watch?v=', '').gsub('&t', '').gsub(' ', '')
  end
end
