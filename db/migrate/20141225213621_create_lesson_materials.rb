class CreateLessonMaterials < ActiveRecord::Migration
  def change
    create_table :lesson_materials do |t|
      t.integer :instructor_id
      t.string :name
      t.text :description
      t.string :document
      t.timestamps
    end
  end
end
