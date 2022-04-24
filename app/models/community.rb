class Community < ApplicationRecord
  belongs_to :user

  validates :name, uniqueness: true, presence: true

  before_save :sanitize_discord_key

  scope :all_from, ->(country_code) { where(country_code: country_code) }

  def sanitize_discord_key
    self.discord = self.discord.gsub("https://discord.gg/", "")
  end

end
