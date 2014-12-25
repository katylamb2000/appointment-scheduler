class LessonMaterial < ActiveRecord::Base
  validates_presence_of :instructor_id, :name, :document
  validates_uniqueness_of :name

  belongs_to :instructor, class_name: "User"
end