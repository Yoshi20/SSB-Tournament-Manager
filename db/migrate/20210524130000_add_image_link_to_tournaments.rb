class AddImageLinkToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :image_link, :string
    add_column :tournaments, :image_height, :string
    add_column :tournaments, :image_width, :string
  end
end
