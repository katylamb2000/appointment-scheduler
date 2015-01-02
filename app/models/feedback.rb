class Feedback < ActiveRecord::Base
  validates_presence_of :user_id, :appointment_id, :notes, :context
  validates :context, inclusion: { in: ["left by instructor", "left by student"] }
  validates_uniqueness_of :user_id, scope: :appointment_id

  belongs_to :user
  belongs_to :appointment
end