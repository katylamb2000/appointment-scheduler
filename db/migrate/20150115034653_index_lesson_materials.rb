class IndexLessonMaterials < ActiveRecord::Migration
  def change
    add_index :lesson_materials, :instructor_id
  end
end
