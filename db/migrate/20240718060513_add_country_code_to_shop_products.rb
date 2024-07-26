class AddCountryCodeToShopProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_products, :country_code, :string
    Shop::Product.includes(:user).all.each do |sp|
      if sp.respond_to?(:country_code)
        sp.update(country_code: sp.user.country_code)
      end
    end
  end
end
