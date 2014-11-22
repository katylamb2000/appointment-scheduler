admin = User.find_by(admin: true)
User.create(email: "admin@sbguitar.com", password: "password", admin: true, first_name: "Tam", last_name: "Dang") unless admin

shawn = User.find_by(email: "shawn@sbguitar.com")
User.create(email: "shawn@sbguitar.com", password: "password", instructor: true, first_name: "Shawn", last_name: "Baldissero") unless shawn

todd = User.find_by(email: "todd@sbguitar.com")
User.create(email: "todd@sbguitar.com", password: "password", instructor: true, first_name: "Todd", last_name: "Dang-Baldissero") unless todd

goop = User.find_by(email: "goop@cats.com")
User.create(email: "goop@cats.com", password: "password", first_name: "Frau Goop", last_name: "The Ruthless Cat", city: "Chicago", country: "US", age: 20) unless goop

john_doe = User.find_by_email("johndoe@guest.com")
User.create(email: "johndoe@guest.com", first_name: "John", city: "Boston", country: "US", age: 31, guest: true) unless john_doe

thirty_minute_appt = AppointmentCategory.find_by_lesson_minutes(30)
AppointmentCategory.create(lesson_minutes: 30, buffer_minutes: 15, price: 50.00) unless thirty_minute_appt

one_hour_appt = AppointmentCategory.find_by_lesson_minutes(60)
AppointmentCategory.create(lesson_minutes: 60, buffer_minutes: 15, price: 90.00) unless one_hour_appt