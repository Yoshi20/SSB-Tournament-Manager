class AddCreatedAtToRegistrations < ActiveRecord::Migration[5.1]
  def up
    add_timestamps :registrations, default: Time.zone.now
    change_column_default :registrations, :created_at, nil
    change_column_default :registrations, :updated_at, nil
  end
  def down
    remove_column :registrations, :created_at
    remove_column :registrations, :updated_at
  end
end
