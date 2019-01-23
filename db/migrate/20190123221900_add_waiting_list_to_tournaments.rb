class AddWaitingListToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :waiting_list, :string, array: true, default: []
  end
end
