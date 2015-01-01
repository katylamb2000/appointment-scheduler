class UsersController < ApplicationController

  def student_dashboard
    @past_appts = current_user.past_appointments.includes(:appointment_category, :instructor)
    @upcoming_appts = current_user.upcoming_appointments.includes(:appointment_category, :instructor)
    @student_materials = current_user.student_materials.includes(:lesson_material)
  end

  def profile_photo_processing
    user = User.find(params[:id])
    render json: { loading: user.profile_photo_processing, url: user.profile_photo.thumb.url }
  end

end