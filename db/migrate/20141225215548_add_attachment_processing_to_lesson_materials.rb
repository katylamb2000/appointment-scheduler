class AddAttachmentProcessingToLessonMaterials < ActiveRecord::Migration
  def change
    add_column :lesson_materials, :attachment_processing, :boolean, null: false, default: false
  end
end
