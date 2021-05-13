class News < ApplicationRecord
  belongs_to :user

  validates :title, :presence => true
  validates :teaser, :presence => true
  validates :text, :presence => true

  MAX_NEWS_PER_PAGE = 10

end
