class AddBraacketMatchIdToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :braacket_match_id, :string

  end
end
