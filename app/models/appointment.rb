class Appointment < ActiveRecord::Base
  validates_presence_of :user_id, :instructor_id, :appointment_category_id, :start_time, :status
end