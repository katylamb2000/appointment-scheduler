class Admin < User
  default_scope { where(admin: true) }

  rails_admin do
    list do
      field :email
      field :last_sign_in_at
      field :current_sign_in_at
    end

    show do
      field :admin
      field :instructor
      field :email
      field :last_sign_in_at
      field :created_at
      field :updated_at
    end

    edit do
      field :admin
      field :instructor
      field :email
      field :first_name do
        help do
          "Optional. Length up to 255."
        end
      end
      field :last_name
      field :password do
        help do
          "Leave blank if you don't want to change."
        end
      end
      field :password_confirmation do
        label do
          "Confirm Password"
        end
        help do
          "Retype new password"
        end
      end
    end
  end
end