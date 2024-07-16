class Survey < ApplicationRecord
  has_many :survey_responses, dependent: :destroy

  scope :active, -> { where('ends_at > ?', DateTime.now) }

end
