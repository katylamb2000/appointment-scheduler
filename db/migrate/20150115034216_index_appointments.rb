class IndexAppointments < ActiveRecord::Migration
  def change
    add_index :appointments, :instructor_id
    add_index :appointments, :student_id
    add_index :appointments, :appointment_category_id
    add_index :appointments, :availability_id
  end
end
