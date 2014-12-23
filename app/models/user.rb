class User < ActiveRecord::Base
  # TODO verify compatibility across languages, specifically non-Arabic alphabets
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  validates_presence_of :first_name
  validates_presence_of :city, :country, :age, unless: Proc.new { |u| u.admin? || u.instructor? }
  validates :gender, inclusion: { in: :gender_options }, allow_nil: true, allow_blank: true
  validates :age, numericality: { greater_than_or_equal_to: 18 }, allow_nil: true, allow_blank: true
  validates :skill_level, inclusion: { in: :skill_level_options }, allow_nil: true, allow_blank: true
  validates :musical_genre, inclusion: { in: :musical_genre_options }, allow_nil: true, allow_blank: true
  validates :years_playing, inclusion: { in: :years_playing_options }, allow_nil: true, allow_blank: true
  validate :accepted_age_agreement, unless: Proc.new { |u| u.admin? || u.instructor? }

  # TODO: dependent destroy ON ALL MODELS? or acts as paranoid? also papertrail?

  # as Student TODO: extract into Student model?
  has_many :appointments
  has_many :instructors, through: :appointments, source: :instructor

  # as Instructor TODO: extract into Instructor model? so that we can call Instructor.appointments
  has_many :availabilities, foreign_key: "instructor_id"
  has_many :lessons, class_name: "Appointment", foreign_key: "instructor_id"
  has_many :students, through: :lessons, source: :user

  def gender_options
    ["male", "female"]
  end

  def skill_level_options
    ["Beginner", "Intermediate", "Advanced", "Master"]
  end

  def musical_genre_options
    ["Pop", "Jazz", "Classical", "Progressive", "Metal", "Rock", "Country", "Fusion", "Funk", "Other"]
  end

  def years_playing_options
    ["1 - 2", "3 - 5", "5 - 10", "10 +"]
  end

  def accepted_age_agreement
    errors.add(:base, "You must certify that you are over 18 to create an account." ) unless accepts_age_agreement
  end

  def admin?
    admin
  end

  def instructor?
    instructor
  end

  def guest?
    guest
  end

  def student?
    student
  end

  def student
    !admin? && !instructor?
  end

  def full_name
    last_name.blank? ? first_name : "#{last_name}, #{first_name}"
  end

  def location
    (city && country) ? "#{city}, #{country}" : ""
  end

  def can_book?(appointment_id) # TODO refactor this in conjunction with appointments controller. it should return a boolean
    appointment = Appointment.find(appointment_id)
    appointment.user = self
    appointment.status = "Booked - Future"
    if appointment.valid?
      return { can_book: true }
    else
      return { can_book: false, errors: appointment.errors.full_messages }
    end
  end

  def has_stripe_id?
    !(stripe_id.blank?)
  end

  def stripe_customer
    has_stripe_id? ? retrieve_stripe_customer! : create_stripe_customer!
  end

  def retrieve_stripe_customer!
    Stripe::Customer.retrieve(stripe_id)
  end

  def create_stripe_customer!
    stripe_cust = Stripe::Customer.create(
      email: email,
      metadata: {
        rails_id: id,
        first_name: first_name
      }
    )
    persist_stripe_information!(stripe_cust["id"])
    return stripe_cust
  end

  def persist_stripe_information!(stripe_customer_id)
    update_attribute(:stripe_id, stripe_customer_id)
  end

  rails_admin do
    object_label_method do
      :full_name
    end

    list do
      field :id
      field :email
      field :first_name
      field :location
      field :age
      field :gender
    end

    show do
      field :id
      field :instructor
      field :admin
      field :guest
      field :student, :boolean
      field :email
      field :full_name

      field :availabilities do
        visible do
          bindings[:controller].current_user.admin?
        end
      end

      field :lessons do
        visible do
          bindings[:controller].current_user.admin?
        end
      end

      field :students do
        visible do
          bindings[:controller].current_user.admin?
        end
      end

      field :appointments do
        visible do
          bindings[:controller].current_user.admin?
        end
      end

      field :instructors do
        visible do
          bindings[:controller].current_user.admin?
        end
      end
      
      field :gender
      field :age
      field :skill_level
      field :musical_genre
      field :years_playing
      field :city
      field :state
      field :zip
      field :country
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

    create do
      field :instructor
      field :admin
      field :email
      field :password
      field :password_confirmation do
        help do
          "Retype password."
        end
      end
      field :first_name
      field :last_name

      field :gender, :enum do
        enum do
          bindings[:object].gender_options
        end
      end

      field :age, :enum do
        enum do
          (18...85).to_a
        end
        help do
          "Required unless Admin or Instructor. Length up to 255."
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
      
      field :city do
        help do
          "Required unless Admin or Instructor. Length up to 255."
        end
      end
      field :state
      field :zip
      field :country do
        help do
          "Required unless Admin or Instructor. Length up to 255."
        end
      end
    end

    edit do
      field :instructor
      field :admin
      field :email

      field :password do
        visible do
          bindings[:object].id == bindings[:controller].current_user.id
        end
        help do
          "Leave blank if you don't want to change."
        end
      end

      field :password_confirmation do
        visible do
          bindings[:object].id == bindings[:controller].current_user.id
        end
        help do
          "Retype new password."
        end
      end

      field :first_name
      field :last_name

      field :gender, :enum do
        enum do
          bindings[:object].gender_options
        end
      end

      field :age, :enum do
        enum do
          (18...85).to_a
        end
        help do
          "Required unless Admin or Instructor."
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
      
      field :city do
        help do
          "Required unless Admin or Instructor. Length up to 255."
        end
      end
      field :state
      field :zip
      field :country do
        help do
          "Required unless Admin or Instructor. Length up to 255."
        end
      end
    end
  end

  protected

    def password_required? # overrride Devise method so that Guest Users do not need passwords
      guest? ? false : (!persisted? || !password.nil? || !password_confirmation.nil?)
    end
end
