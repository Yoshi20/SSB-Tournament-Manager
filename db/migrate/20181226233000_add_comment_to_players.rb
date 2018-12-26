class AddCommentToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :comment, :text
  end
end
