class AppointmentsController < ApplicationController
  prepend_before_filter :allow_params_authentication!, only: :update

  def index
    @appointments = Appointment.upcoming.open_or_booked.order(:start_time)
    # TODO group by dates
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  def update
    @appointment = Appointment.find(params[:id]) # TODO rescue from ActiveRecord::NotFound
    if new_user?
      @new_user = User.new(user_params)
      if @new_user.save
        sign_in(@new_user)
      else
        render "users/auth" and return
      end
    end

    render "users/auth" and return unless current_user
    bookable = current_user.can_book?(@appointment.id)
    if bookable[:can_book]
      render action: "confirm_modal"
      # render "users/authenticate" # haml view (HTML)
      # TODO reserve for 15 minutes?
        # change status to Reserved (On Hold), Trying to be Booked, etc
        # set sidekiq process in 15 minutes, send appointment id
        # when sidekiq process runs, check to see if that appointment has been paid for
        # if not, set appointment to Open
        # but how do we locate that session for that user to kick them out of the booking process?
        # can we implement a countdown timer?
    else
      @errors = bookable[:errors] # TODO error messages that are meaningful to both customers and admins
      render action: "unbookable"
    end
  end

  private

    def new_user?
      params.has_key?("new_user")
    end

    def user_params
      params.require(:new_user).permit(:email, :password, :password_confirmation, :first_name, :city, :country, :age)
    end
end