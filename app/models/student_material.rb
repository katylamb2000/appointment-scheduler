class StudentMaterial < ActiveRecord::Base
  validates_presence_of :user_id, :lesson_material_id
  
end