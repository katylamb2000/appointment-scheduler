class Users::RegistrationsController < Devise::RegistrationsController

  def update
    delete_password_params! if not_updating_password?
    @user = current_user
    if @user.update(user_params)
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true # Sign in the user bypassing validation in case their password changed
      redirect_to after_update_path_for(@user)
    else
      flash[:errors] = current_user.errors
      render :edit
    end
  end

  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :profile_photo, :profile_photo_cache, :age, :gender, :city, :state, :zip, :country, :skill_level, :musical_genre, :years_playing)
    end

    def not_updating_password?
      params[:user][:password].blank? && params[:user][:password_confirmation].blank?
    end

    def delete_password_params!
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    def after_update_path_for(resource)
      edit_user_registration_path
    end
  
end