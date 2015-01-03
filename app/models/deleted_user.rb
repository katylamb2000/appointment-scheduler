class DeletedUser < User
  default_scope { User.only_deleted }
  
  rails_admin do
    navigation_label "Users"
  end
end