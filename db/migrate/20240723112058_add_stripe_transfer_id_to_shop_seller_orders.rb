class AddStripeTransferIdToShopSellerOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_seller_orders, :stripe_transfer_id, :string
  end
end
