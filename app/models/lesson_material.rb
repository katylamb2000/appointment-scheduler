class LessonMaterial < ActiveRecord::Base
  validates_presence_of :instructor_id, :name, :document
  validates_uniqueness_of :name
end