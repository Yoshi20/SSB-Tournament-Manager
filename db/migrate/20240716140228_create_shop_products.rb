class CreateShopProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_products do |t|
      t.string :name, null: false, default: ""
      t.string :description, default: ""
      t.string :currency
      t.float :price, null: false, default: 0
      t.float :shipping, null: false, default: 0
      t.integer :stock, null: false, default: 0
      t.boolean :is_hidden, default: true
      t.integer :position

      t.string :image_link
      t.string :image_height
      t.string :image_width

      t.timestamps
    end
    add_column :shop_products, :user_id, :bigint
    add_foreign_key :shop_products, :users
    add_index :shop_products, :user_id
  end
end
