class IndexAppointmentsOnStatus < ActiveRecord::Migration
  def change
    add_index :appointments, :status
  end
end
