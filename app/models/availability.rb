class Availability < ActiveRecord::Base
  belongs_to :instructor, class_name: "User"

  validates_presence_of :instructor, :start_time, :end_time
  validate :end_time_must_be_after_start_time, :duration_must_be_at_least_one_hour # TODO validate hours are 00 or 30 ?

  def end_time_must_be_after_start_time
    errors.add(:end_time, "must be after start time.") unless end_time > start_time
  end

  def duration_must_be_at_least_one_hour
    errors.add(:base, "Duration must be at least one hour.") unless (end_time >= start_time + 1.hour)
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
      Appointment.create(appointment_category: @thirty_minute_appt, instructor: self.instructor, start_time: start_time, status: "Open")
    end
  end

  rails_admin do
    list do
      field :id
      field :instructor
      field :start_time
      field :end_time
    end

    show do
      field :id
      field :instructor
      field :start_time
      field :end_time
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