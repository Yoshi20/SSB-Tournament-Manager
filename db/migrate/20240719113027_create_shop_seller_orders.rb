class CreateShopSellerOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_seller_orders do |t|
      t.boolean :was_order_sent, default: false
      t.datetime :order_sent_at
      t.string :status, default: "", null: false
      t.string :stripe_account_id
      t.timestamps
    end
    add_column :shop_seller_orders, :shop_order_id, :bigint
    add_foreign_key :shop_seller_orders, :shop_orders
    add_index :shop_seller_orders, :shop_order_id
    add_column :shop_seller_orders, :user_id, :bigint
    add_foreign_key :shop_seller_orders, :users
    add_index :shop_seller_orders, :user_id

    remove_column :shop_orders, :was_order_sent, :boolean
    remove_column :shop_orders, :order_sent_at, :datetime
  end
end
