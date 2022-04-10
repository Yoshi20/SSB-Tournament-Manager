class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name_long
      t.string :name_short
      t.string :description
      t.string :website
      t.string :discord
      t.string :twitter
      t.string :instagram
      t.string :facebook
      t.string :youtube
      t.string :twitch
      t.string :image_link
      t.string :image_height
      t.string :image_width
      t.string :region
      t.string :country_code
      t.boolean :is_sponsoring_players
      t.boolean :is_recruiting
      t.string :recruiting_description

      t.timestamps
    end
  end
end
