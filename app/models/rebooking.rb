class Rebooking < ActiveRecord::Base
  validates_uniqueness_of :dead_appointment_id
  validates_uniqueness_of :new_appointment_id
  validates_presence_of :dead_appointment_id, :new_appointment_id

  belongs_to :dead_appointment, class_name: "Appointment"
  belongs_to :new_appointment, class_name: "Appointment"

  rails_admin do
    list do
      field :id
      field :dead_appointment
      field :new_appointment
      field :created_at
      field :updated_at
    end

    show do
      field :id
      field :dead_appointment
      field :new_appointment
      field :created_at
      field :updated_at
    end
  end
end