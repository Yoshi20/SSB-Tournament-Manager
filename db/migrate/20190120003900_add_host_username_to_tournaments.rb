class AddHostUsernameToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :host_username, :string
  end
end
