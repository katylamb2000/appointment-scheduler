class Rebooking < ActiveRecord::Base
  validates_uniqueness_of :dead_appointment_id
  validates_uniqueness_of :new_appointment_id
  validates_presence_of :dead_appointment_id, :new_appointment_id

  belongs_to :dead_appointment, class_name: "Appointment"
  belongs_to :new_appointment, class_name: "Appointment"
end