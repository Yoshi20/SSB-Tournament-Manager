class AddCountryCodeToShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :shopping_carts, :country_code, :string
  end
end
