class Feedback < ApplicationRecord
  belongs_to :user

  validates :text, :presence => true

  scope :all_from, ->(country_code) { where(country_code: country_code) }

  MAX_FEEDBACKS_PER_PAGE = 10

end
