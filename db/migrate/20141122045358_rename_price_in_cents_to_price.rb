class RenamePriceInCentsToPrice < ActiveRecord::Migration
  def change
    rename_column :appointment_categories, :price_in_cents, :price
  end
end
