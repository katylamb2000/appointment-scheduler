class IndexAvailabilities < ActiveRecord::Migration
  def change
    add_index :availabilities, :instructor_id
  end
end
