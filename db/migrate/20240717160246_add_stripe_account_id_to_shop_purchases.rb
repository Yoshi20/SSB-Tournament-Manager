class AddStripeAccountIdToShopPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_purchases, :stripe_account_id, :string
  end
end
