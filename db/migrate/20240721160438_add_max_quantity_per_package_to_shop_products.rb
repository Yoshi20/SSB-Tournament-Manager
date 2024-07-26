class AddMaxQuantityPerPackageToShopProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_products, :max_quantity_per_package, :integer, null: false, default: 1
  end
end
