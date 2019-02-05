class AddMinNeededRegistrationsToTournaments < ActiveRecord::Migration[5.1]
  def up
    add_column :tournaments, :min_needed_registrations, :integer
    Tournament.all.each do |t|
      if t.total_seats.present?
        t.min_needed_registrations = t.total_seats/2
      else
        t.min_needed_registrations = 0
      end
      t.save!
    end
  end

  def down
    remove_column :tournaments, :min_needed_registrations
  end
end
