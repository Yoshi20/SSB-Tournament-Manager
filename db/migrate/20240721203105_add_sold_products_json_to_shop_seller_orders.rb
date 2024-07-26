class AddSoldProductsJsonToShopSellerOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_seller_orders, :sold_products_json, :json
    add_column :shop_seller_orders, :currency, :string
    add_column :shop_seller_orders, :shipping_costs, :float, null: false, default: 0
    add_column :shop_seller_orders, :total_price, :float, null: false, default: 0
    add_column :shop_seller_orders, :total_fee, :float, null: false, default: 0
  end
end
