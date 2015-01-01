class DeletedUser < User
  default_scope { User.only_deleted }
end