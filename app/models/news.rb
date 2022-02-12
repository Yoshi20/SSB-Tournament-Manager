class News < ApplicationRecord
  belongs_to :user

  before_create :set_country_code

  validates :title, :presence => true
  validates :teaser, :presence => true
  validates :text, :presence => true

  scope :all_ch, -> { where(country_code: 'ch') }

  MAX_NEWS_PER_PAGE = 20

end
