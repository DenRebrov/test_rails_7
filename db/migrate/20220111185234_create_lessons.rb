class CreateLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :lessons do |t|
      t.references :topic, foreign_key: true
      t.string :title
      t.string :body
      t.string :video
      t.integer :number, default: 0
      t.string :shape
      t.string :coords
      
      t.timestamps
    end
  end
end
