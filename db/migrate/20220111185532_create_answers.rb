class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.references :question, foreign_key: true
      t.boolean :correct, default: false
      t.string :body
      
      t.timestamps
    end
  end
end
