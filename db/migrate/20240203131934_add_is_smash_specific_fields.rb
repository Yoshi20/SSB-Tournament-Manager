class AddIsSmashSpecificFields < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :allows_emails_from_smashiceland, :boolean, default: true
  end
end
