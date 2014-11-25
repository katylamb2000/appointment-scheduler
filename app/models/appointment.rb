class Appointment < ActiveRecord::Base
  before_validation :set_end_time

  validates_presence_of :appointment_category_id, :availability_id, :instructor_id, :start_time, :end_time, :status
  validates_presence_of :user_id, unless: Proc.new { |record| record.open? }
  # TODO auto-maintaining the status of appointments
  validates :status, inclusion: { in: :status_options }
  validates :re_bookable, inclusion: { in: [true, false] }
  validate :end_time_must_be_after_start_time
  validate :start_time_cannot_be_in_past, on: :create

  # LOGIC MAGIC: (end_time is greater than start_time) && (start_time is less than end_time)
  validates :start_time, :end_time, :overlap => {
    scope: "instructor_id",
    :query_options => { :valid => nil }, # for Rebookings, dead appointments
    exclude_edges: ["start_time", "end_time"],
    message_title: :base,
    :message_content => "Time slot overlaps with instructor's other appointments."
  }

  validates :start_time, :end_time, :overlap => {
    scope: "user_id",
    :query_options => { :valid => nil }, # for Rebookings, dead appointments
    exclude_edges: ["start_time", "end_time"],
    message_title: :base,
    :message_content => "Time slot overlaps with student's other appointments."
  }, unless: Proc.new { |record| record.open? }

  after_save :create_rebooking_and_new_appointment, if: Proc.new { |record| record.re_bookable_changed? && record.dead? }

  belongs_to :appointment_category
  belongs_to :availability
  belongs_to :user
  belongs_to :instructor, class_name: "User"
  has_one :rebooking, foreign_key: "old_appointment_id"
  has_one :rebooked_appointment, through: :rebooking, source: :new_appointment
  has_one :reverse_rebooking, class_name: "Rebooking", foreign_key: "new_appointment_id"
  has_one :original_appointment, through: :reverse_rebooking, source: :old_appointment

  scope :valid, -> { where(re_bookable: false) } # necessary for time_overlaps validation
  scope :available, -> { where(status: "Open") } # TODO assumes excellent maintenance of "status". could be user_id: nil ?
  scope :on_day, -> (date_object) { where('start_time > ?', date_object.beginning_of_day).where('end_time < ?', date_object.end_of_day) }
  scope :today, -> { on_day(Date.today) } # TODO edgecase: overnight appt. assumes UTC time
  scope :available_today, -> { today.available }
  scope :available_on_day, -> (date_object) { on_day(date_object).available}

  def end_time_must_be_after_start_time
    errors.add(:end_time, "must be after start time.") unless end_time > start_time
  end

  def start_time_cannot_be_in_past
    errors.add(:start_time, "cannot be in the past") unless start_time >= (DateTime.now - 5.minutes)
  end

  def create_rebooking_and_new_appointment
    new_appt = Appointment.create(instructor: self.instructor, appointment_category: self.appointment_category, start_time: self.start_time, availability: self.availability, status: "Open")
    Rebooking.create(old_appointment: self, new_appointment: new_appt)
  end

  def status_options
    ["Open", "Future", "Past - Occurred", "Cancelled by Student", "Cancelled by Instructor", "Rescheduled by Student", "Rescheduled by Instructor", "No Show", "Unavailable"]
  end

  def name
    "##{id}"
  end

  def set_end_time
    self.end_time = (self.start_time + self.appointment_category.total_duration.minutes)
  end

  def lesson_duration
    appointment_category.lesson_minutes
  end

  def buffer_duration
    appointment_category.buffer_minutes
  end

  def total_duration
    appointment_category.total_duration
  end

  def taken?
    !(open?)
  end

  def open?
    status == "Open" || user_id.nil?
  end

  def future?
    status == "Future"
  end

  def unavailable?
    status == "Unavailable"
  end

  def editable_status_by_instructor?
    open? || future? || unavailable?
  end

  def dead?
    re_bookable == true
  end

  rails_admin do

    label_plural do
      "All Appointments"
    end

    label do
      "Appointment"
    end

    list do
      field :id
      field :instructor

      field :user do
        label do
          "Student"
        end
      end

      field :start_time do
        strftime_format "%a %m/%e, %l:%M %p"
      end

      field :appointment_category
      field :status
    end

    show do
      field :id
      field :instructor

      field :user do
        label do
          "Student"
        end
      end

      field :appointment_category

      field :start_time do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
      end

      field :end_time do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
      end

      field :status
      field :availability

      field :created_at do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
        visible do
          bindings[:view].current_user.admin?
        end
      end

      field :updated_at do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
        visible do
          bindings[:view].current_user.admin?
        end
      end
    end

    edit do
      field :instructor do
        inline_add false
        inline_edit false
        visible do
          bindings[:view].current_user.admin?
        end
        associated_collection_scope do
          Proc.new { |scope| scope = scope.where(instructor: true) }
        end
      end

      field :user do
        inline_add false
        inline_edit false
        label do
          "Student"
        end
        read_only do
          !(bindings[:view].current_user.admin?)
        end
        help do
          !(bindings[:view].current_user.admin?) ? "" : "#{help}"
        end
        associated_collection_scope do
          Proc.new { |scope| scope = scope.where(instructor: false).where(admin: false) }
        end
      end

      field :appointment_category do
        inline_add false
        inline_edit false
        read_only do
          !(bindings[:view].current_user.admin?)
        end
        help do
          !(bindings[:view].current_user.admin?) ? "" : "#{help}"
        end
      end

      field :start_time do
        read_only do
          !(bindings[:view].current_user.admin?)
        end
        help do
          !(bindings[:view].current_user.admin?) ? "" : "#{help}"
        end
      end

      field :status, :enum do
        read_only do
          !(bindings[:view].current_user.admin?) && !(bindings[:object].editable_status_by_instructor?)
        end
        enum do
          bindings[:object].status_options
        end
        help do
          "Required. An Appoinment marked 'Unavailable' will not be available to any Students, as long as it is not marked as 'Re-bookable' (see next field)."
        end
      end

      field :re_bookable do
        read_only do
          !(bindings[:view].current_user.admin?) && bindings[:object].dead?
        end
        label do
          "Re-bookable?"
        end
        help do
          "IMPORTANT: Marking an Appointment 'Re-bookable' will open it up to be booked by other Students. An Appointment is usually 'Re-bookable' when a previous Student cancelled his/her appointment, with enough time to allow another Student to take the slot."
        end
      end
    end
  end
end