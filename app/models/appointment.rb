class Appointment < ActiveRecord::Base
  before_validation :set_end_time

  validates_presence_of :instructor_id, :appointment_category_id, :start_time, :end_time, :status
  validates :status, inclusion: { in: ["Open", "Future", "Past - Occurred", "Cancelled by Student", "Cancelled by Instructor", "Rescheduled by Student", "Rescheduled by Instructor", "No Show"] }
  validates_presence_of :user_id, unless: Proc.new{ |record| record.open? }
  validate :does_not_overlap_other_appointments

  belongs_to :appointment_category
  belongs_to :user
  belongs_to :instructor, class_name: "User"

  def set_end_time
    self.end_time = (self.start_time + self.appointment_category.total_duration.minutes)
  end

  def does_not_overlap_other_appointments
  end

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

  def open?
    status == "Open"
  end

  rails_admin do
    list do
      field :id
      field :instructor
      field :user do
        label do
          "Student"
        end
      end
      field :appointment_category
      field :start_time
      field :status
    end

    show do
      field :id
      field :instructor
      field :user do
        label do
          "Student"
        end
      end
      field :appointment_category
      field :start_time
      field :end_time
      field :status
    end
  end
end