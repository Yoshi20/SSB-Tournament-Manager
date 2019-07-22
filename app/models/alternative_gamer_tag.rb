class AlternativeGamerTag < ApplicationRecord
  belongs_to :player

  before_validation :strip_whitespace

  validates :gamer_tag, presence: true
  validates :gamer_tag, uniqueness: true

  def strip_whitespace
    self.gamer_tag.try(:strip!)
  end
end
