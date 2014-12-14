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
      render 'users/authenticate'
    end
  end
end