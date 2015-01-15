class Admin < User

  rails_admin do
    navigation_label "Users"
    visible do
      bindings[:controller].current_user.admin?
    end

    object_label_method do
      :full_name
    end
    
    list do
      scopes [:active, :only_deleted]
      field :id
      field :email
      field :first_name
      field :last_sign_in_at
      field :current_sign_in_at
    end

    show do
      field :id
      field :admin
      field :email
      field :full_name
      field :profile_photo
      field :gender
      field :age
      field :skill_level
      field :musical_genre
      field :years_playing
      field :city
      field :state
      field :zip
      field :country
      field :sign_in_count
      field :last_sign_in_at
      field :created_at
      field :updated_at
    end

    create do
      field :admin
      field :email
      field :first_name
      field :last_name
      field :profile_photo
      field :password

      field :password_confirmation do
        help do
          "Retype Password."
        end
      end

      field :gender, :enum do
        enum do
          bindings[:object].gender_options
        end
      end

      field :age, :enum do
        enum do
          (18...85).to_a
        end
        help do
          "Optional."
        end
      end

      field :skill_level, :enum do
        enum do
          bindings[:object].skill_level_options
        end
      end

      field :musical_genre, :enum do
        enum do
          bindings[:object].musical_genre_options
        end
      end

      field :years_playing, :enum do
        enum do
          bindings[:object].years_playing_options
        end
      end
      
      field :city do
        help do
          "Optional. Length up to 255."
        end
      end

      field :state
      field :zip

      field :country do
        help do
          "Optional. Length up to 255."
        end
      end
    end

    edit do
      field :admin
      field :email
      field :first_name
      field :last_name
      field :profile_photo

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

      field :gender, :enum do
        enum do
          bindings[:object].gender_options
        end
      end

      field :age, :enum do
        enum do
          (18...85).to_a
        end
        help do
          "Optional."
        end
      end

      field :skill_level, :enum do
        enum do
          bindings[:object].skill_level_options
        end
      end

      field :musical_genre, :enum do
        enum do
          bindings[:object].musical_genre_options
        end
      end

      field :years_playing, :enum do
        enum do
          bindings[:object].years_playing_options
        end
      end
      
      field :city do
        help do
          "Optional. Length up to 255."
        end
      end

      field :state
      field :zip
      
      field :country do
        help do
          "Optional. Length up to 255."
        end
      end
    end
  end
end