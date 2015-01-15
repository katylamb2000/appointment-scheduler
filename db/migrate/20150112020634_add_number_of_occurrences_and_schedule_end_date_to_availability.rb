class AddNumberOfOccurrencesAndScheduleEndDateToAvailability < ActiveRecord::Migration
  def change
    add_column :availabilities, :number_of_occurrences, :integer
    add_column :availabilities, :schedule_end_date, :datetime
  end
end
