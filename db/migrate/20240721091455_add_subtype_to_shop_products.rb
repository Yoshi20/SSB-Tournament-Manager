class AddSubtypeToShopProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_products, :subtype, :string, null: false, default: "service"
  end
end
