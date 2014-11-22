class Guest < User
  default_scope { where(guest: true) }

  rails_admin do
    visible do
      bindings[:controller].current_user.admin?
    end

    list do
      field :email
      field :city
      field :country
      field :age
    end
  end
end