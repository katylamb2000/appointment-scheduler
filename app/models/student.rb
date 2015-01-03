class Student < User
  has_many :appointments
  has_many :upcoming_appointments, -> { where("start_time > ?", DateTime.now) }, class_name: "Appointment"
  has_many :past_appointments, -> { where("end_time < ?", DateTime.now) }, class_name: "Appointment"
  has_many :instructors, -> { uniq }, through: :appointments
  has_many :student_materials
  has_many :lesson_materials, through: :student_materials
  has_many :given_feedbacks, foreign_key: "user_id", class_name: "Feedback"
  has_many :received_feedbacks, ->(student) { where.not(user_id: student.id) }, through: :appointments, source: :feedbacks

  # def upcoming_appointments
  #   appointments.where("start_time > ?", DateTime.now)
  # end

  # def past_appointments
  #   appointments.where("end_time < ?", DateTime.now)
  # end

  def self_cancelled_appointments
    appointments.where(status: "Cancelled by Student")
  end

  def self_cancelled_count
    self_cancelled_appointments.count
  end

  def self_rescheduled_appointments
    appointments.where(status: "Rescheduled by Student")
  end

  def self_rescheduled_count
    self_rescheduled_appointments.count
  end

  def instructor_cancelled_appointments
    appointments.where(status: "Cancelled by Instructor")
  end

  def instructor_cancellation_count
    instructor_cancelled_appointments.count
  end

  def instructor_rescheduled_appointments
    appointments.where(status: "Rescheduled by Instructor")
  end

  def instructor_rescheduled_count
    instructor_rescheduled_appointments.count
  end

  rails_admin do
    navigation_label "Users"

    object_label_method do
      :full_name
    end

    list do
      scopes [:active, :only_deleted]
      field :id
      field :email
      field :first_name
      field :location
      field :age
      field :gender
    end

    show do
      field :given_feedbacks
      field :received_feedbacks
      field :id
      field :guest
      field :student, :boolean
      field :email
      field :full_name
      field :profile_photo
      field :gender
      field :age
      field :skill_level
      field :musical_genre
      field :years_playing
      field :city
      field :state
      field :zip
      field :country

      field :appointments do
        visible do
          bindings[:view].current_user.admin?
        end
      end

      field :instructors do # TODO make unique
        visible do
          bindings[:view].current_user.admin?
        end
      end

      field :sign_in_count
      field :last_sign_in_at

      field :created_at do
        visible do
          bindings[:view].current_user.admin?
        end
      end
      
      field :updated_at do
        visible do
          bindings[:view].current_user.admin?
        end
      end
    end

    edit do
      field :email
      field :first_name
      field :last_name
      field :profile_photo do
        visible do
          !(bindings[:object].guest?)
        end
      end

      field :gender, :enum do
        enum do
          bindings[:object].gender_options
        end
      end

      field :age, :enum do
        enum do
          (18...85).to_a
        end
      end

      field :skill_level, :enum do
        enum do
          bindings[:object].skill_level_options
        end
      end

      field :musical_genre, :enum do
        enum do
          bindings[:object].musical_genre_options
        end
      end

      field :years_playing, :enum do
        enum do
          bindings[:object].years_playing_options
        end
      end
      
      field :city
      field :state
      field :zip
      field :country
    end
  end
end