class RenameShopParams < ActiveRecord::Migration[7.1]
  def change
    rename_column :shop_purchases, :shop_product_id, :product_id
    rename_column :shop_seller_orders, :shop_order_id, :order_id
  end
end
