class AddStudentNotesToStudentMaterials < ActiveRecord::Migration
  def change
    add_column :student_materials, :student_notes, :text
  end
end
