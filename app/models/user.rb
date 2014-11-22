class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  validates_presence_of :first_name, unless: Proc.new { |u| u.admin? }
  validates_presence_of :city, :country, :age, unless: Proc.new { |u| u.admin? || u.instructor? }
  validates :gender, inclusion: { in: ["male", "female"] }, allow_nil: true
  validates :age, numericality: { greater_than_or_equal_to: 18 }, allow_nil: true
  validates :skill_level, inclusion: { in: ["Beginner", "Intermediate", "Advanced", "Master"] }, allow_nil: true
  validates :musical_genre, inclusion: { in: ["Pop", "Jazz", "Classical", "Progressive", "Metal", "Rock", "Country", "Fusion", "Funk", "Other"] }, allow_nil: true
  validates :years_playing, inclusion: { in: ["1 - 2", "3 - 5", "5 - 10", "10 +"] }, allow_nil: true

  # TODO: dependent destroy? or acts as paranoid?
  has_many :availabilities, foreign_key: "instructor_id"
  has_many :appointments # as a student
  has_many :lessons, class_name: "Appointment", foreign_key: "instructor_id"
  has_many :students, through: :lessons, source: :user

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
      field :full_name
      field :email
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
    end

    edit do
      field :instructor
      field :admin
      field :first_name
      field :last_name
      field :email

      field :gender, :enum do
        enum do
          ["male", "female"]
        end
      end

      field :age, :enum do
        enum do
          (18...85).to_a
        end
      end

      field :skill_level, :enum do
        enum do
          ["Beginner", "Intermediate", "Advanced", "Master"] 
        end
      end

      field :musical_genre, :enum do
        enum do
          ["Pop", "Jazz", "Classical", "Progressive", "Metal", "Rock", "Country", "Fusion", "Funk", "Other"]
        end
      end

      field :years_playing, :enum do
        enum do
          ["1 - 2", "3 - 5", "5 - 10", "10 +"]
        end
      end
      
      field :city
      field :state
      field :zip
      field :country
    end
  end

  protected

    def password_required? # overrride Devise method so that Guest Users do not need passwords
      guest? ? false : (!persisted? || !password.nil? || !password_confirmation.nil?)
    end
end
