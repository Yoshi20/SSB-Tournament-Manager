class AddIsSuperAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_super_admin, :boolean
  end
end
