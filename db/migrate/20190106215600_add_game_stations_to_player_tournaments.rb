class AddGameStationsToPlayerTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :player_tournaments, :game_stations, :integer
  end
end
