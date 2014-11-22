class CreateRebookings < ActiveRecord::Migration
  def change
    create_table :rebookings do |t|
      t.integer :dead_appointment_id
      t.integer :new_appointment_id
      t.timestamps
    end
  end
end
