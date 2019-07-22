class AddDiscordUsernameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discord_username, :string
  end
end
