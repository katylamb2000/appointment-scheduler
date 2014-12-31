class Users::SessionsController < Devise::SessionsController

  def create # account for acts_as_paranoid deleted users
    if (resource = resource_class.only_deleted.find_by_email(params[resource_name][:email]))
      if resource.valid_password?(params[resource_name][:password])
        resource.restore!
        sign_in resource
      end
    end
    super
  end
  
end