class StudentMailer < ActionMailer::Base
  default from: "TODO@sbguitar.com"

  def reminder_email(appt_id)
    @appointment = Appointment.find(appt_id)
    mail(to: @appointment.user.email, subject: "REMINDER: Your upcoming lesson.")
  end
end