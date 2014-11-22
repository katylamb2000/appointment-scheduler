class Student < User
  default_scope { where(instructor: false).where(admin: false) }

  rails_admin do
    object_label_method do
      :full_name
    end

    list do
      field :id
      field :email
      field :first_name
      field :location
      field :age
      field :gender
    end

    show do
      field :id
      field :guest
      field :student, :boolean
      field :email
      field :full_name
      field :gender
      field :age
      field :skill_level
      field :musical_genre
      field :years_playing
      field :city
      field :state
      field :zip
      field :country
      field :appointments do
        visible do
          bindings[:view].current_user.admin?
        end
      end
      field :instructors do # TODO make unique
        visible do
          bindings[:view].current_user.admin?
        end
      end
      field :sign_in_count
      field :last_sign_in_at
      field :created_at do
        visible do
          bindings[:view].current_user.admin?
        end
      end
      field :updated_at do
        visible do
          bindings[:view].current_user.admin?
        end
      end
    end

    edit do
      field :email
      field :first_name
      field :last_name

      field :gender, :enum do
        enum do
          ["male", "female"]
        end
      end

      field :age, :enum do
        enum do
          (18...85).to_a
        end
      end

      field :skill_level, :enum do
        enum do
          ["Beginner", "Intermediate", "Advanced", "Master"] 
        end
      end

      field :musical_genre, :enum do
        enum do
          ["Pop", "Jazz", "Classical", "Progressive", "Metal", "Rock", "Country", "Fusion", "Funk", "Other"]
        end
      end

      field :years_playing, :enum do
        enum do
          ["1 - 2", "3 - 5", "5 - 10", "10 +"]
        end
      end
      
      field :city
      field :state
      field :zip
      field :country
    end
  end
end