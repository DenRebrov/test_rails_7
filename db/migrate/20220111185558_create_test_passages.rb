class CreateTestPassages < ActiveRecord::Migration[7.0]
  def change
    create_table :test_passages do |t|
      t.references :user, foreign_key: true
      t.references :test, foreign_key: true
      t.integer :correct_questions, default: 0
      t.boolean :passed, default: false
      t.integer :current_question_id, index: true

      t.boolean :help_fifty_fifty_used, default: false, null: false
      t.boolean :help_overtime_used, default: false, null: false
      t.boolean :help_google_hint_used, default: false, null: false
      t.boolean :help_error_protection_used, default: false, null: false

      t.timestamps
    end
  end
end
