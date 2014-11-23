class Availability < ActiveRecord::Base
  belongs_to :instructor, class_name: "User"
  has_many :appointments

  validates_presence_of :instructor, :start_time, :end_time
  validate :end_time_must_be_after_start_time, :duration_must_be_at_least_one_hour # TODO validate hours are 00 or 30 ?
  validate :start_time_cannot_be_in_past, on: :create

  after_create :to_forty_five_minute_appointments

  def end_time_must_be_after_start_time
    errors.add(:end_time, "must be after start time.") unless end_time > start_time
  end

  def start_time_cannot_be_in_past
    errors.add(:start_time, "cannot be in the past") unless start_time >= (Time.now - 5.minutes)
  end

  def duration_must_be_at_least_one_hour
    errors.add(:base, "Duration must be at least one hour.") unless (end_time >= start_time + 1.hour)
  end

  def name
    "##{id}"
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

    label_plural do
      "All Availabilities"
    end

    label do
      "Availability"
    end

    list do
      field :id
      field :instructor

      field :start_time do
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
          Proc.new { |scope| scope = scope.where(instructor: true) }
        end
      end

      field :start_time
      field :end_time
    end
  end

end