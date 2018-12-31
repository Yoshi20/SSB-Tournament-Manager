class RenameCommentToDescription < ActiveRecord::Migration[5.1]
  def change
    rename_column :tournaments, :comment, :description
  end
end
