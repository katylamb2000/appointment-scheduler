module DeviseHelper

  def devise_error_messages!
    flash[:errors] = resource.errors.full_messages
  end
  
end