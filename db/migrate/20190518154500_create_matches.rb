class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.belongs_to :tournament, index: true

      t.bigint :challonge_match_id
      t.bigint :player1_id
      t.bigint :player2_id
      t.integer :player1_score
      t.integer :player2_score
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
