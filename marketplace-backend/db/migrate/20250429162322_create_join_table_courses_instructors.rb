class CreateJoinTableCoursesInstructors < ActiveRecord::Migration[8.0]
  def change
    create_join_table :courses, :instructors do |t|
      t.index [:course_id, :instructor_id]
      t.index [:instructor_id, :course_id]
    end
  end
end
