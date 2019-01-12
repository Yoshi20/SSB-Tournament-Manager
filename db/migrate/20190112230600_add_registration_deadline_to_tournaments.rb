class AddRegistrationDeadlineToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :registration_deadline, :datetime
  end
end
