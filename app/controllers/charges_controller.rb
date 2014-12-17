class ChargesController < ApplicationController

  def create
    @amount = params[:appointment][:price].to_i
    @appointment = Appointment.find(params[:appointment][:id])
    customer = current_user.stripe_customer

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Testing123',
      :currency    => 'usd',
      :metadata   => {
        rails_appt_id: params[:appointment][:id],
        rails_customer_id: current_user.id
      }
    )
    
    @appointment.user = current_user
    @appointment.save
    # if successful:
      # set 
    redirect_to @appointment

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
  end

end
