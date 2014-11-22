class Admin < User
  default_scope { where(admin: true) }

  rails_admin do

    visible do
      bindings[:controller].current_user.admin?
    end

    object_label_method do
      :full_name
    end
    
    list do
      field :id
      field :email
      field :first_name
      field :last_sign_in_at
      field :current_sign_in_at
    end

    show do
      field :id
      field :admin
      field :instructor
      field :email
      field :full_name
      field :last_sign_in_at
      field :created_at
      field :updated_at
    end

    create do
      field :admin
      field :instructor
      field :email
      field :first_name
      field :last_name
      field :password
      field :password_confirmation do
        help do
          "Retype Password."
        end
      end
    end

    edit do
      field :admin
      field :instructor
      field :email
      field :first_name
      field :last_name

      field :password do

        visible do
          bindings[:object].id == bindings[:controller].current_user.id
        end

        help do
          "Leave blank if you don't want to change."
        end
      end

      field :password_confirmation do

        visible do
          bindings[:object].id == bindings[:controller].current_user.id
        end

        label do
          "Confirm Password."
        end

        help do
          "Retype new password."
        end
      end
    end
  end
end