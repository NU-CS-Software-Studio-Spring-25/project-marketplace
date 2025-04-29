class CreateJoinTableCoursesQuarters < ActiveRecord::Migration[7.0]
  def change
    create_join_table :courses, :quarters do |t|
      t.index [:course_id, :quarter_id]
      t.index [:quarter_id, :course_id]
    end
  end
end
