class AddVariantsToShopProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_products, :variants, :string
  end
end
