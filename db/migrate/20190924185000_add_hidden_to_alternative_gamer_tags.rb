class AddHiddenToAlternativeGamerTags < ActiveRecord::Migration[5.1]
  def change
    add_column :alternative_gamer_tags, :hidden, :boolean, default: false
  end
end
