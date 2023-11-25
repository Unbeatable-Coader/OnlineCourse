class AddCourseIdToEnrollments < ActiveRecord::Migration[7.1]
  def change
    add_reference :enrollments, :course, null: false, foreign_key: true
  end
end
