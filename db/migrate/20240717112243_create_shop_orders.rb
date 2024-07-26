class CreateShopOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_orders do |t|
      t.string :organisation
      t.string :name
      t.string :address
      t.string :address2
      t.string :zip_code
      t.string :city
      t.string :phone_number
      t.string :email, default: "", null: false
      t.boolean :was_order_sent, default: false
      t.datetime :order_sent_at
      t.boolean :was_order_paid, default: false
      t.datetime :order_paid_at
      t.string :status, default: "", null: false
      t.timestamps
    end
    add_column :shop_orders, :shopping_cart_id, :bigint
    add_foreign_key :shop_orders, :shopping_carts
    add_index :shop_orders, :shopping_cart_id
  end
end
