class AddTelegramToCommunities < ActiveRecord::Migration[7.0]
  def change
    add_column :communities, :telegram, :string
  end
end
