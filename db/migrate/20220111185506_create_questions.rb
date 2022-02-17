class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.references :test, foreign_key: true
      t.string :body
      t.text :hint
      t.text :help_hash
      t.integer :time_start, default: 0
      t.string :format, default: :common
      
      t.timestamps
    end
  end
end
