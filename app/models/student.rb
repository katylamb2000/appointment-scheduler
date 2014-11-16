class Student < User
  default_scope { where(instructor: false).where(admin: false) }
end