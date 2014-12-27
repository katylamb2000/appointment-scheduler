class UsersController < ApplicationController

  def student_dashboard
    @past_appts = current_user.past_appointments
    @upcoming_appts = current_user.upcoming_appointments
  end
  
end