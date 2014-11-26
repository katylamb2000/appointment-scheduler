class AppointmentsController < ApplicationController

  def index
    # TODO only show taken ("Future") and open appointments - don't show cancelled/rescheduled/unavailable
    @appointments = Appointment.order(:start_time)
  end
end