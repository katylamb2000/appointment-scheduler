class Appointment < ActiveRecord::Base
  validates_presence_of :user_id, :instructor_id, :appointment_category_id, :start_time, :status
  validates :status, inclusion: { in: ["Future", "Past - Occurred", "Cancelled by Student", "Cancelled by Instructor", "Rescheduled by Student", "Rescheduled by Instructor", "No Show"] }

  belongs_to :appointment_category
end