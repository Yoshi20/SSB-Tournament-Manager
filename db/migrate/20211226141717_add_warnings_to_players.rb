class AddWarningsToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :warnings, :integer
  end
end
