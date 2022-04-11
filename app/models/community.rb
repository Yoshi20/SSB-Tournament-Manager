class Community < ApplicationRecord
  belongs_to :user

  validates :name, uniqueness: true, presence: true

  scope :all_fr, -> { where(country_code: 'fr') }

end
