class RemoveInstructorBooleanFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :instructor
  end
end
