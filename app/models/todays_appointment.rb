class TodaysAppointment < Appointment
  default_scope { where('start_time > ?', Date.today.beginning_of_day).where('end_time < ?', Date.today.end_of_day) }
end