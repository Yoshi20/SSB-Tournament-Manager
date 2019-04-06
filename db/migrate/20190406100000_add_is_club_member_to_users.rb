class AddIsClubMemberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_club_member, :boolean, default: false
    add_column :users, :wants_major_email, :boolean, default: true
    add_column :users, :wants_weekly_email, :boolean, default: true
  end
end
