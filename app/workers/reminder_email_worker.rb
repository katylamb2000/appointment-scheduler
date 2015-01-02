class ReminderEmailWorker
  include Sidekiq::Worker

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(appt_id)
    StudentMailer.reminder_email(appt_id).deliver
    logger.info("StudentMailer#reminder_email called for Appointment with ID #{appt_id}")
  end
end