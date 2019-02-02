class AddMainCharacterToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :main_characters, :string, array: true, default: []
  end
end
