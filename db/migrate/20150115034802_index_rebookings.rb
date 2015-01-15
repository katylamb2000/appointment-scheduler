class IndexRebookings < ActiveRecord::Migration
  def change
    add_index :rebookings, :old_appointment_id
    add_index :rebookings, :new_appointment_id
  end
end
