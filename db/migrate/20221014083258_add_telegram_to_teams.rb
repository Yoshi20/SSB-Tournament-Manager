class AddTelegramToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :telegram, :string
  end
end
