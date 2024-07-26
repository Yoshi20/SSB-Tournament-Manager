class AddCurrencyToShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :shopping_carts, :currency, :string
    Shop::ShoppingCart.all.each do |sc|
      if sc.respond_to?(:currency)
        sc.update(currency: sc.purchases.first&.currency)
      end
    end
  end
end
