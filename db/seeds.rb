Admin.create(email: "admin@sbguitar.com", password: "password", admin: true, first_name: "Tam", last_name: "Dang")

Instructor.create(email: "shawn@sbguitar.com", password: "password", first_name: "Shawn", last_name: "Baldissero")

Instructor.create(email: "todd@sbguitar.com", password: "password", first_name: "Todd", last_name: "Dang-Baldissero")

Student.create(email: "goop@cats.com", password: "password", first_name: "Frau Goop", last_name: "The Ruthless Cat", city: "Chicago", country: "US", age: 20, accepts_age_agreement: true, confirmed_at: Time.now)

thirty_minute_appt = AppointmentCategory.find_by_lesson_minutes(30)
AppointmentCategory.create(lesson_minutes: 30, buffer_minutes: 15, price: 50.00) unless thirty_minute_appt

one_hour_appt = AppointmentCategory.find_by_lesson_minutes(60)
AppointmentCategory.create(lesson_minutes: 60, buffer_minutes: 15, price: 90.00) unless one_hour_appt