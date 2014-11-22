class AddAvailabilityIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :availability_id, :integer
  end
end
