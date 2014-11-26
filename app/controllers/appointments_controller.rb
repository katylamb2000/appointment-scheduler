class AppointmentsController < ApplicationController

  def index
    @appointments = Appointment.upcoming.open_or_booked.order(:start_time)
    # TODO group by dates
  end

  def update
    appointment = Appointment.find(params[:id])
    if current_user
      puts "YOU'RE LOGGED IN YEAH"
    else
      puts "NO ONE IS HOME"
    end
    puts appointment.id
    redirect_to appointments_path, notice: "Huzzah!"
  end
end