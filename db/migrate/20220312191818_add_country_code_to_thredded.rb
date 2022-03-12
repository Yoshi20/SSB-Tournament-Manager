class AddCountryCodeToThredded < ActiveRecord::Migration[5.2]
  def change
    add_column :thredded_messageboards, :country_code, :string
    add_column :thredded_posts, :country_code, :string
    add_column :thredded_messageboard_groups, :country_code, :string
  end
end
