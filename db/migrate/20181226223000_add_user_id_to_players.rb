class AddUserIdToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :user_id, :bigint
    add_foreign_key :players, :users
  end
end
