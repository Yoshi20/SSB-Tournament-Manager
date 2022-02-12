class CreateCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :communities do |t|
      t.string :name
      t.string :city
      t.string :department
      t.string :region
      t.string :country_code
      t.string :discord
      t.string :twitter
      t.string :instagram
      t.string :facebook
      t.string :youtube
      t.string :twitch
    end
  end
end
