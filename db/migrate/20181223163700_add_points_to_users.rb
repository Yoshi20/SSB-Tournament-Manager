class AddPointsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :points, :integer
		add_column :users, :participations, :integer
		add_column :users, :self_assessment, :integer
		add_column :users, :tournament_experience, :integer

  end
end
