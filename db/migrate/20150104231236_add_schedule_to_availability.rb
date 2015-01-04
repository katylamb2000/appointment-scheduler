class AddScheduleToAvailability < ActiveRecord::Migration
  def change
    add_column :availabilities, :schedule, :text
  end
end
