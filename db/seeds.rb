admin = User.find_by(admin: true)
User.create(email: "admin@sbguitar.com", password: "password", admin: true, first_name: "Tam", last_name: "Dang") unless admin

shawn = User.find_by(email: "shawn@sbguitar.com")
User.create(email: "shawn@sbguitar.com", password: "password", instructor: true, first_name: "Shawn", last_name: "Baldissero") unless shawn