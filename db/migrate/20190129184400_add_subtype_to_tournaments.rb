class AddSubtypeToTournaments < ActiveRecord::Migration[5.1]
  def up
    add_column :tournaments, :subtype, :string
    Tournament.all.each do |t|
      t.subtype = 'internal'
      t.save!
    end

    # subtype == weekly
    add_column :tournaments, :city, :string
    add_column :tournaments, :end_date, :datetime

    # subtype == external
    add_column :tournaments, :external_registration_link, :string
  end

  def down
    remove_column :tournaments, :subtype
    remove_column :tournaments, :city
    remove_column :tournaments, :end_date
    remove_column :tournaments, :external_registration_link
  end
end
