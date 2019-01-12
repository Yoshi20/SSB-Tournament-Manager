class AddChallongeUsernameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :challonge_username, :string
    add_column :users, :challonge_api_key, :string
  end
end
