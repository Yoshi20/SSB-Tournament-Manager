class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.belongs_to :user

      t.bigint :user_id
      t.string :title
      t.string :teaser
      t.text :text
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
