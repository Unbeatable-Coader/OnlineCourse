class AddColumnsTocourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :video, :string
    add_column :courses, :document, :string
  end
end
