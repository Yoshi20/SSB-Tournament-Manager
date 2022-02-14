class CreateDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :donations do |t|
      t.string :message_id
      t.string :timestamp
      t.string :type
      t.boolean :is_public
      t.string :from_name
      t.string :message
      t.string :amount
      t.string :url
      t.string :email
      t.string :currency
      t.boolean :is_subscription_payment
      t.boolean :is_first_subscription_payment
      t.string :kofi_transaction_id
      t.string :verification_token
      t.string :shop_items
      t.string :tier_name
      t.string :country_code
    end
  end
end
