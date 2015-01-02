class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.integer :appointment_id
      t.string :context
      t.text :notes
      t.boolean :anonymous, default: false
      t.timestamps
    end
  end
end
