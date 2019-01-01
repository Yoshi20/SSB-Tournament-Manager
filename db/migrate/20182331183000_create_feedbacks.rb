class CreateFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :feedbacks do |t|
      t.belongs_to :user

      t.bigint :user_id
      t.text :text
      t.text :response
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
