class CreateSurveys < ActiveRecord::Migration[7.1]
  def change
    create_table :surveys do |t|
      t.string :question
      t.string :option1
      t.string :option2
      t.string :option3
      t.datetime :ends_at

      t.timestamps
    end
  end
end
