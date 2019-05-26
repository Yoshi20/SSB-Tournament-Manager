class AddCantonToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :canton, :string
    add_column :players, :gender, :string
    add_column :players, :birth_year, :integer

  end
end
