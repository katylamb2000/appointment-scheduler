class AddRebookableToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :re_bookable, :boolean, default: false
  end
end
