class AddPaidAtToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :paid_at, :datetime
  end
end
