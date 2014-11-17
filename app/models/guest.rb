class Guest < User
  default_scope { where(guest: true) }
end