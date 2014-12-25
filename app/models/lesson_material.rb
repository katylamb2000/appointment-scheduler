class LessonMaterial < ActiveRecord::Base
  validates_presence_of :instructor_id, :name, :attachment
  validates_uniqueness_of :name

  belongs_to :instructor, class_name: "User"

  mount_uploader :attachment, AttachmentUploader
  process_in_background :attachment
end