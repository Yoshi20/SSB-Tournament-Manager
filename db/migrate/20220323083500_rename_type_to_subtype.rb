class RenameTypeToSubtype < ActiveRecord::Migration[5.1]
  def change
    rename_column :donations, :type, :subtype
  end
end
