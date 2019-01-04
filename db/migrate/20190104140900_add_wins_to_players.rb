class AddWinsToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :best_rank, :integer
    add_column :players, :wins, :integer
    add_column :players, :losses, :integer
  end
end
