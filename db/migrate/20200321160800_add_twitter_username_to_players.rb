class AddTwitterUsernameToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :twitter_username, :string
    add_column :players, :instagram_username, :string
  end
end
