class AddNumberOfPoolsToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :number_of_pools, :integer, default: 0
  end
end
