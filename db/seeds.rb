admin = User.find_by(admin: true)
User.create(email: "admin@sbguitar.com", password: "password", admin: true, first_name: "Tam", last_name: "Dang") unless admin

shawn = User.find_by(email: "shawn@sbguitar.com")
User.create(email: "shawn@sbguitar.com", password: "password", instructor: true, first_name: "Shawn", last_name: "Baldissero") unless shawn

thirty_minute_appt = AppointmentCategory.find_by_lesson_minutes(30)
AppointmentCategory.create(lesson_minutes: 30, buffer_minutes: 15, price_in_cents: 5000) unless thirty_minute_appt

one_hour_appt = AppointmentCategory.find_by_lesson_minutes(60)
AppointmentCategory.create(lesson_minutes: 60, buffer_minutes: 15, price_in_cents: 9000) unless one_hour_appt