class Rebooking < ActiveRecord::Base
  belongs_to :dead_appointment, class_name: "Appointment"
  belongs_to :new_appointment, class_name: "Appointment"
end