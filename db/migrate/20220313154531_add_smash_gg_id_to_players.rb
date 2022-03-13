class AddSmashGgIdToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :smash_gg_id, :string
    add_column :players, :nintendo_friend_code, :string
    add_column :players, :twitch_username, :string
  end
end
