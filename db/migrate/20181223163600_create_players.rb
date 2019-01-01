class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :gamer_tag
      t.integer :points
      t.integer :participations
      t.integer :self_assessment
      t.integer :tournament_experience
      t.text :comment
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
