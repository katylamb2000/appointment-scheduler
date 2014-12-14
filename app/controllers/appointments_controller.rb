class AppointmentsController < ApplicationController

  def index
    @appointments = Appointment.upcoming.open_or_booked.order(:start_time)
    # TODO group by dates
  end

  def update
    @appointment = Appointment.find(params[:id]) # TODO rescue from ActiveRecord::NotFound
    if current_user
      @appointment.user = current_user
      @appointment.status = "Booked - Future"
      if @appointment.save
        redirect_to appointments_path, notice: "Huzzah!"
      else
        redirect_to appointments_path, alert: "Rat Shardz!"
      end
    else
      # TODO reserve for 15 minutes?
        # change status to Reserved (On Hold), Trying to be Booked, etc
        # set sidekiq process in 15 minutes, send appointment id
        # when sidekiq process runs, check to see if that appointment has been paid for
        # if not, set appointment to Open
        # but how do we locate that session for that user to kick them out of the booking process?
        # can we implement a countdown timer?
      render 'users/authenticate'
    end
  end
end