class CreateJoinTableCoursesLabels < ActiveRecord::Migration[8.0]
  def change
    create_join_table :courses, :labels do |t|
      t.index [:course_id, :label_id]
      t.index [:label_id, :course_id]
    end
  end
end
