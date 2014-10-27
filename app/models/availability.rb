class Availability < ActiveRecord::Base
  belongs_to :instructor, class_name: "User"

  validates_presence_of :instructor, :start_time, :end_time
  # TODO validate end time is after start time ?
  # TODO validate hours are 00 or 30 ?
  # TODO validate start time and end time are on same day?

end