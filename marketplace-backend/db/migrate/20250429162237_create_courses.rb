class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :course_number
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :courses, :course_number, unique: true
  end
end
