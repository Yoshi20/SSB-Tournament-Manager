class AddShippingInternationalToShopProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_products, :shipping_international, :float, null: false, default: 0
    rename_column :shop_products, :shipping, :shipping_national
  end
end
