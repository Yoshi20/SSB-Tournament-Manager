class Donation < ApplicationRecord
  before_create :set_country_code

  scope :all_ch, -> { where(country_code: 'ch') }

end
