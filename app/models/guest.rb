class Guest < User
  default_scope { where(guest: true) }

  rails_admin do
    list do
      field :email
      field :city
      field :country
      field :age
    end
  end
end