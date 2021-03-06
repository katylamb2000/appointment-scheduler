class Appointment < ActiveRecord::Base
  validates_presence_of :user_id, :instructor_id, :appointment_category_id, :start_time, :status
  validates :status, inclusion: { in: ["Future", "Past - Occurred", "Cancelled by Student", "Cancelled by Instructor", "Rescheduled by Student", "Rescheduled by Instructor", "No Show"] }

  belongs_to :appointment_category
  belongs_to :user
  belongs_to :instructor, class_name: "User"

  def lesson_duration
    appointment_category.lesson_minutes
  end

  def buffer_duration
    appointment_category.buffer_minutes
  end

  def total_duration
    appointment_category.total_duration
  end

  def end_time
    start_time + total_duration.minutes
  end
end