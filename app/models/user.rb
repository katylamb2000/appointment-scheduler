class User < ActiveRecord::Base
  # TODO verify compatibility across languages, specifically non-Arabic alphabets
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  validates_presence_of :first_name
  validates_presence_of :city, :country, :age, unless: Proc.new { |u| u.admin? || u.instructor? }
  validates :gender, inclusion: { in: :gender_options }, allow_nil: true, allow_blank: true
  validates :age, numericality: { greater_than_or_equal_to: 18 }, allow_nil: true, allow_blank: true
  validates :skill_level, inclusion: { in: :skill_level_options }, allow_nil: true, allow_blank: true
  validates :musical_genre, inclusion: { in: :musical_genre_options }, allow_nil: true, allow_blank: true
  validates :years_playing, inclusion: { in: :years_playing_options }, allow_nil: true, allow_blank: true
  validate :accepted_age_agreement, unless: Proc.new { |u| u.admin? || u.instructor? }

  after_create :make_student!, if: Proc.new { |u| u.type.nil? }

  # TODO: dependent destroy ON ALL MODELS? or acts as paranoid? also papertrail?

  mount_uploader :profile_photo, ProfilePhotoUploader
  process_in_background :profile_photo

  scope :active, -> { where(deleted_at: nil) }
  scope :only_deleted, -> { where.not(deleted_at: nil) }

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

  def make_student!
    update_attribute(:type, "Student")
  end

  def admin?
    is_a?(Admin) || admin
  end

  def instructor?
    is_a?(Instructor)
  end

  def student?
    is_a?(Student)
  end

  def dead?
    !!(deleted_at)
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
    appointment.student = self
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

  def soft_delete
    update_attribute(:deleted_at, Time.now)
  end

  def restore!
    update_attribute(:deleted_at, nil)
  end

  def active_for_authentication? # overrwrite Devise; Users who have deleted themselves cannot sign in
    super && !deleted_at
  end

  protected

    def confirmation_required?
      student?
    end

  rails_admin do
    visible false
  end

end
