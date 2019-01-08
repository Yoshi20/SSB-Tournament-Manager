class AddPaidFeeToRegistrations < ActiveRecord::Migration[5.1]
  def change
    add_column :registrations, :paid_fee, :float
  end
end
