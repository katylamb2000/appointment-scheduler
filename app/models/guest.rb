class Guest < User
  default_scope { where(guest: true) }

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
      field :location
      field :age
      field :gender
    end

    show do
      field :id
      field :instructor
      field :admin
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
      field :appointments
      field :instructors # TODO make unique
      field :sign_in_count
      field :last_sign_in_at
      field :created_at
      field :updated_at
    end

    edit do
      field :instructor
      field :admin
      field :email
      field :first_name
      field :age, :enum do
        enum do
          (18...85).to_a
        end
      end
      field :city
      field :country
    end
  end
end