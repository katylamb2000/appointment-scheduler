class ChangeUserIdToStudentIdOnAppointmentsAndStudentMaterials < ActiveRecord::Migration
  def change
    rename_column :appointments, :user_id, :student_id
    rename_column :student_materials, :user_id, :student_id
  end
end
