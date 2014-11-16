class Admin < User
  default_scope { where(admin: true) }
end