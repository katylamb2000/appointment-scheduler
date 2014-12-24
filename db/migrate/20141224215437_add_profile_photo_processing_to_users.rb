class AddProfilePhotoProcessingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_photo_processing, :boolean, null: false, default: false
  end
end
