class Availability < ActiveRecord::Base
  include IceCube
  serialize :schedule, IceCube::Schedule # Hash ?

  validates_presence_of :instructor, :start_time, :end_time
  validate :end_time_must_be_after_start_time, :duration_must_be_at_least_one_hour # TODO validate hours are 00 or 30 ?
  validate :start_time_cannot_be_in_past, on: :create
  validate :can_be_edited?, if: Proc.new { |record| record.time_changed? }
  validate :only_number_of_occurrences_or_schedule_end_date_can_be_set
  validates :start_time, :end_time, :overlap => {
    scope: "instructor_id",
    exclude_edges: ["start_time", "end_time"],
    message_title: :base,
    :message_content => "Time slot overlaps with instructor's other availabilities."
  }

  after_create :to_forty_five_minute_appointments

  belongs_to :instructor
  has_many :appointments

  scope :on_day, -> (date_object) { where('start_time > ?', date_object.beginning_of_day).where('end_time < ?', date_object.end_of_day) }
  scope :today, -> { on_day(Date.today) } # TODO edgecase: overnight appt. assumes UTC time

  def end_time_must_be_after_start_time
    errors.add(:end_time, "must be after start time.") unless end_time > start_time
  end

  def start_time_cannot_be_in_past
    errors.add(:start_time, "cannot be in the past") unless start_time >= (Time.now - 5.minutes)
  end

  def duration_must_be_at_least_one_hour
    errors.add(:base, "Duration must be at least one hour.") unless (end_time >= start_time + 1.hour)
  end

  def only_number_of_occurrences_or_schedule_end_date_can_be_set
    errors.add(:base, "You can only set a number of occurrences OR a scheduled end date, but not both") unless (schedule_end_date.blank? || number_of_occurrences.blank?)
  end

  def can_be_edited?
    errors.add(:base, "This availability has upcoming appointments. Please cancel or reschedule them in order to edit this availability.") unless !(has_pending_appointments?)
  end

  def name
    "##{id}"
  end

  def description
    start_time.strftime("%a %m/%e, %l:%M %p") + " - " + end_time.strftime("%a %m/%e, %l:%M %p")
  end

  def active?
    has_occurrences_left?
  end

  def has_occurrences_left?
    !!(schedule.next_occurrence)
  end

  def occurs_between?(start_time, end_time)
    schedule.occurs_between?(start_time, end_time)
  end

  def occurrences_between(start_time, end_time)
    schedule.occurrences_between(start_time, end_time)
  end

  def time_changed?
    start_time_changed? || end_time_changed?
  end

  def has_pending_appointments?
    !(appointments.where(status: "Booked - Future").empty?)
  end

  def forty_five_minute_chunks
    start = start_time
    appointment_times = [start]
    until (start + 75.minutes) > end_time
      start += 45.minutes
      appointment_times.push(start)
    end
    appointment_times
  end

  def to_forty_five_minute_appointments
    @thirty_minute_appt = AppointmentCategory.find_by_lesson_minutes(30)
    forty_five_minute_chunks.each do |start_time|
      Appointment.create(appointment_category: @thirty_minute_appt, instructor: self.instructor, availability: self, start_time: start_time, status: "Open")
    end
  end

  rails_admin do

    list do
      scopes [:today, nil]
      field :id
      field :instructor

      field :start_time do # TODO creating an Availability in RailAdmin always assumes you are putting in central time values.
        strftime_format "%a %m/%e, %l:%M %p"
      end
      
      field :end_time do
        strftime_format "%a %m/%e, %l:%M %p"
      end
    end

    show do
      field :id
      field :instructor

      field :start_time do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
      end

      field :end_time do
        strftime_format "%A, %B %e, %Y - %l:%M %p"
      end

      field :appointments

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
          Proc.new { |scope| scope = scope.active }
        end
      end

      field :start_time
      field :end_time
    end
  end

end