class AddCantonToTournaments < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :canton, :string
  end
end
