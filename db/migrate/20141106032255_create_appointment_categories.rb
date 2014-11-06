class CreateAppointmentCategories < ActiveRecord::Migration
  def change
    create_table :appointment_categories do |t|
      t.integer :lesson_minutes
      t.integer :buffer_minutes
      t.float :price_in_cents
      t.timestamps
    end
  end
end
