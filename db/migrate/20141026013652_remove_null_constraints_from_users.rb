class RemoveNullConstraintsFromUsers < ActiveRecord::Migration
  def change
    change_column :users, :city, :string, null: true
    change_column :users, :country, :string, null: true
    change_column :users, :age, :integer, null: true
  end
end
