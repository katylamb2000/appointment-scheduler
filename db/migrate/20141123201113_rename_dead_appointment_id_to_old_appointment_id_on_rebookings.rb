class RenameDeadAppointmentIdToOldAppointmentIdOnRebookings < ActiveRecord::Migration
  def change
    rename_column :rebookings, :dead_appointment_id, :old_appointment_id
  end
end
