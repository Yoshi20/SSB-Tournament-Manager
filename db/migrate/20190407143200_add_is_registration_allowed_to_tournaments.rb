class AddIsRegistrationAllowedToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :is_registration_allowed, :boolean, default: true
  end
end
