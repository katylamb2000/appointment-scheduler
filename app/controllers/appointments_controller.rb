class AppointmentsController < ApplicationController

  def index
    @appointments = Appointment.open_or_booked
    # TODO group by dates
  end
end