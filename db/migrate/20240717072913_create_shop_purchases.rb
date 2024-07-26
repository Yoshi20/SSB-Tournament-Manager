class CreateShopPurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_purchases do |t|
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
    add_column :shop_purchases, :shop_product_id, :bigint
    add_foreign_key :shop_purchases, :shop_products
    add_index :shop_purchases, :shop_product_id
    add_column :shop_purchases, :shopping_cart_id, :bigint
    add_foreign_key :shop_purchases, :shopping_carts
    add_index :shop_purchases, :shopping_cart_id
  end
end
