class AddMembersCounterToTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :members_counter, :integer, default: 0
  end
end
