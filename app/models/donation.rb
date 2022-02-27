class Donation < ApplicationRecord
  before_create :set_country_code

  scope :all_from, ->(country_code) { where(country_code: country_code) }

end
