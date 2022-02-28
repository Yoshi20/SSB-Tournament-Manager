class AlternativeGamerTag < ApplicationRecord
  belongs_to :player

  before_validation :strip_whitespace

  validates :gamer_tag, uniqueness: true, presence: true
  validate :validate_gamer_tag_is_truly_uniq

  scope :all_from, ->(country_code) { where(country_code: country_code) }

  def validate_gamer_tag_is_truly_uniq
    if Player.all_from(self.country_code).exists?(gamer_tag: self.gamer_tag)
      errors.add(:gamer_tag, I18n.t('not_uniq'))
    end
  end

  def strip_whitespace
    self.gamer_tag.try(:strip!)
  end
end
