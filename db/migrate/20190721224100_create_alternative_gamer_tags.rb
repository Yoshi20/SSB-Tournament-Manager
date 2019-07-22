class CreateAlternativeGamerTags < ActiveRecord::Migration[5.2]
  def change
    create_table :alternative_gamer_tags do |t|
      t.belongs_to :player, index: true

      t.string :gamer_tag
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
