class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.references :course, foreign_key: true
      t.string :title
      t.string :body
      t.string :video
      t.string :image
      t.string :shape
      t.string :coords
      t.integer :number, default: 0
      
      t.timestamps
    end
  end
end
