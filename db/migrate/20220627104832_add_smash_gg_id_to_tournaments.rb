class AddSmashGgIdToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :smash_gg_id, :bigint
  end
end
