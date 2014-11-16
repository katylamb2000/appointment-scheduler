class Instructor < User
  default_scope { where(instructor: true) }
end