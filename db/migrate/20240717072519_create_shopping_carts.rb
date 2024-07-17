class CreateShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_carts do |t|
      t.string :client_ip
      t.string :session_id
      t.bigint :user_id
      t.boolean :has_checked_out, default: false

      t.timestamps
    end
  end
end
