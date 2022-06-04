class AddPtSmashSpecificFields < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :allows_emails_from_portugalsmash, :boolean, default: true
  end
end
