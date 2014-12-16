class AddStripeChargeIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :stripe_charge_id, :string
  end
end
