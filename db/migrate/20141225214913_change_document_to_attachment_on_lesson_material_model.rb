class ChangeDocumentToAttachmentOnLessonMaterialModel < ActiveRecord::Migration
  def change
    rename_column :lesson_materials, :document, :attachment
  end
end
