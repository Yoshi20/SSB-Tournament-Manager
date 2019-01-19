class RemoveOccupiedSeatsFromTournaments < ActiveRecord::Migration[5.1]
  def change
    remove_column :tournaments, :occupied_seats
  end
end
