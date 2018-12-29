class AddRankingStringToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :ranking_string, :string
  end
end
