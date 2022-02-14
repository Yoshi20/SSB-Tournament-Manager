class AddMainCharacterSkinsToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :main_character_skins, :integer, array: true, default: []
  end
end
