class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :instructor_id
      t.integer :user_id
      t.integer :appointment_category_id
      t.datetime :start_time
      t.string :status
      t.timestamps
    end
  end
end
