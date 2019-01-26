class Feedback < ApplicationRecord
  belongs_to :user

  validates :text, :presence => true

  MAX_FEEDBACKS_PER_PAGE = 10

end
