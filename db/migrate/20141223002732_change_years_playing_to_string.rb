class ChangeYearsPlayingToString < ActiveRecord::Migration
  def change
    change_column :users, :years_playing, :string
  end
end
