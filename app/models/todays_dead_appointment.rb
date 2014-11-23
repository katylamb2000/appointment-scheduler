class TodaysDeadAppointment < Appointment
  default_scope { today.where(status: ["Cancelled by Student", "Cancelled by Instructor", "Rescheduled by Student", "Rescheduled by Instructor"]) }

  rails_admin do
    parent ""
    navigation_label "Today"
    weight 0
    label do
      "Cancelled/Rescheduled Appointment"
    end
  end
end