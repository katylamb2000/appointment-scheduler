class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "weinerboy", password: "ibanez87"
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to(request.referrer || main_app.root_path)
  end

  def after_sign_in_path_for(resource)
    (resource.admin? || resource.instructor?) ? rails_admin_path : root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :city, :country, :age]
  end
end
