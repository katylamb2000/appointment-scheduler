class AppointmentCategory < ActiveRecord::Base
  validates_presence_of :lesson_minutes, :buffer_minutes, :price_in_cents
  validates :lesson_minutes, :buffer_minutes, :price_in_cents, numericality: { greater_than: 0 }
end