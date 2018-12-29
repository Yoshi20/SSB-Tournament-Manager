class AddStartedToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :started, :boolean
    add_column :tournaments, :finished, :boolean
    add_column :tournaments, :challonge_tournament_id, :bigint
  end
end
