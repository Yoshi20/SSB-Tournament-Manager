class AddStripeAccountIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :stripe_account_id, :string
    add_column :users, :stripe_account_is_ready, :boolean, default: 'false'
  end
end
