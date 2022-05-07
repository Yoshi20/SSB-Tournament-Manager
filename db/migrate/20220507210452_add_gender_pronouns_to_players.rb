class AddGenderPronounsToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :gender_pronouns, :string
  end
end
