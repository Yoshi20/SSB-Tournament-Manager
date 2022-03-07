class Community < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  scope :all_fr, -> { where(country_code: 'fr') }

end
