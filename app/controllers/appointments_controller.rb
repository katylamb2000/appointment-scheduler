class AppointmentsController < ApplicationController

  def index
    @appointments = Appointment.upcoming.open_or_booked
    # TODO group by dates
  end
end