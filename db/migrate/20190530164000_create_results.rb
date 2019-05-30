class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.belongs_to :player, index: true
      t.belongs_to :tournament, index: true

      t.string :major_name
      t.integer :rank
      t.integer :points
      t.string :city
      t.integer :wins
      t.integer :losses
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
