class IndexFeedbacks < ActiveRecord::Migration
  def change
    add_index :feedbacks, :user_id
    add_index :feedbacks, :appointment_id
  end
end
