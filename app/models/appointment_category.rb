class AppointmentCategory < ActiveRecord::Base
  validates_presence_of :lesson_minutes, :buffer_minutes, :price_in_cents
  validates_uniqueness_of :lesson_minutes
  validates :lesson_minutes, :buffer_minutes, :price_in_cents, numericality: { greater_than: 0 }

  def total_duration
    lesson_minutes + buffer_minutes
  end
end