class CreateCourseUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :course_users do |t|
      t.belongs_to :course
      t.belongs_to :user
      t.integer :progress, default: 0

      t.index [:course_id, :user_id], unique: true

      t.timestamps
    end
  end
end
