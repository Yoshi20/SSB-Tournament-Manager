class AddVariantToShopPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_purchases, :variant, :string
  end
end
