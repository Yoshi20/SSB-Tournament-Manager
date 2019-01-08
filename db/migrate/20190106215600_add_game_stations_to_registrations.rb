class AddGameStationsToRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :registrations, :game_stations, :integer
  end
end
