class ChargesController < ApplicationController

  def create
    amount = params[:appointment][:price].to_i
    appointment = Appointment.find(params[:appointment][:id])
    stripe_customer = current_user.stripe_customer
    stripe_customer.cards.create(card: params[:stripeToken]) # TODO what if they already have a saved 

    charge = Stripe::Charge.create(
      :customer    => stripe_customer.id,
      :amount      => amount,
      :description => 'Testing123',
      :currency    => 'usd',
      :statement_descriptor => 'sbguitar.com appt',
      :receipt_email => current_user.email,
      :metadata   => {
        rails_appt_id: params[:appointment][:id],
        rails_customer_id: current_user.id
      }
    )
    
    appointment.book!({ student_id: current_user.id, stripe_charge_id: charge.id })
    redirect_to appointment

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path and return
  end

end
