class AddDescriptionShortToShopProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_products, :description_short, :string, default: ""
    Shop::Product.all.each do |p|
      p.update(description_short: p.description) if p.respond_to?(:description_short)
    end
  end
end
