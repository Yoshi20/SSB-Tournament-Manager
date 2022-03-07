class AddPositionToRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :registrations, :position, :integer
  end
end
