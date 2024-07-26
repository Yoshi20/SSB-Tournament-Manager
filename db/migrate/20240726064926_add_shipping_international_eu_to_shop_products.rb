class AddShippingInternationalEuToShopProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_products, :shipping_international_eu, :float, null: false, default: 0
  end
end
