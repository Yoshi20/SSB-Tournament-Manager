class AddTotalNeededGameStationsToTournaments < ActiveRecord::Migration[5.1]
  def up
    add_column :tournaments, :total_needed_game_stations, :integer
    Tournament.all.each do |t|
      if t.total_seats.present?
        t.total_needed_game_stations = t.total_seats/4
      else
        t.total_needed_game_stations = 0
      end
      t.save!
    end
  end

  def down
    remove_column :tournaments, :total_needed_game_stations
  end
end
