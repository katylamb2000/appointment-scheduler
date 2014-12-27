class ChangeNotesOnStudentMaterialsToInstructorNotes < ActiveRecord::Migration
  def change
    rename_column :student_materials, :notes, :instructor_notes
  end
end
