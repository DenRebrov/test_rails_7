class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :body
      t.string :video
      t.string :image
      t.string :category
      t.integer :price, default: 0
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :visible, default: false
      
      t.timestamps
    end
  end
end
