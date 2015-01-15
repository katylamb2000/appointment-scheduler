class IndexStudentMaterials < ActiveRecord::Migration
  def change
    add_index :student_materials, :student_id
    add_index :student_materials, :lesson_material_id
  end
end
