class CreateStudentMaterials < ActiveRecord::Migration
  def change
    create_table :student_materials do |t|
      t.integer :user_id
      t.integer :lesson_material_id
      t.text :notes
      t.timestamps
    end
  end
end
