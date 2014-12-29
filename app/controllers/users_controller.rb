class UsersController < ApplicationController

  def student_dashboard
    @past_appts = current_user.past_appointments.includes(:appointment_category, :instructor)
    @upcoming_appts = current_user.upcoming_appointments.includes(:appointment_category, :instructor)
    @student_materials = current_user.student_materials.includes(:lesson_material)
  end

end