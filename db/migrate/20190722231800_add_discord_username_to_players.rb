class AddDiscordUsernameToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :discord_username, :string
  end
end
