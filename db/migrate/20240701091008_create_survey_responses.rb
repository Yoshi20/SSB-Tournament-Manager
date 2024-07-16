class CreateSurveyResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :survey_responses do |t|
      t.integer :response
      t.string :client_ip
      t.string :country_code
      t.boolean :is_hidden, default: false

      t.timestamps
    end
    add_column :survey_responses, :survey_id, :bigint
    add_foreign_key :survey_responses, :surveys
    add_index :survey_responses, :survey_id
  end
end
