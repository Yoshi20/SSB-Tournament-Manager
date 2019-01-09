class AddSetupToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :setup, :boolean
  end
end
