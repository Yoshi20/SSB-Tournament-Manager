class AddFranceSmashSpecificFields < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :region, :string
    add_column :tournaments, :region, :string

    add_column :users, :allows_emails_from_francesmash, :boolean, default: true
  end
end
