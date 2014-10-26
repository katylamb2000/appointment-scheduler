class AddOtherAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string
    add_column :users, :gender, :string
    add_column :users, :city, :string, null: false
    add_column :users, :state, :string
    add_column :users, :zip, :string
    add_column :users, :country, :string, null: false
    add_column :users, :age, :integer, null: false
    add_column :users, :skill_level, :string
    add_column :users, :musical_genre, :string
    add_column :users, :years_playing, :integer
    add_column :users, :admin, :boolean, default: false
    add_column :users, :instructor, :boolean, default: false
  end
end
