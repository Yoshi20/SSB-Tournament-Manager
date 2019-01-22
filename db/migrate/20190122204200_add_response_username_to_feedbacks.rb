class AddResponseUsernameToFeedbacks < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :response_username, :string
  end
end
