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

end