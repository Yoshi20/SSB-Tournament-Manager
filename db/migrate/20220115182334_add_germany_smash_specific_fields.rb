class AddGermanySmashSpecificFields < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :federal_state, :string
    add_column :tournaments, :federal_state, :string

    add_column :users, :country_code, :string
    add_column :players, :country_code, :string
    add_column :tournaments, :country_code, :string
  end
end
