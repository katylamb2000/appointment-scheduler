class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "weinerboy", password: "ibanez87"
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_filter :set_timezone

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to(request.referrer || main_app.root_path)
  end

  def after_sign_in_path_for(resource)
    (resource.admin? || resource.instructor?) ? rails_admin_path : root_path
  end

  private

    def set_timezone
      client_timezone = cookies[:timezone]
      Time.use_zone(client_timezone) { yield }
    end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [:first_name, :city, :country, :age, :accepts_age_agreement, :profile_photo]
      devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name, :age, :gender, :city, :state, :zip, :country, :skill_level, :musical_genre, :years_playing, :profile_photo]
    end
end
