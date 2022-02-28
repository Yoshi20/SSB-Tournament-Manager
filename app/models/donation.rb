class Donation < ApplicationRecord
  scope :all_from, ->(country_code) { where(country_code: country_code) }

end
