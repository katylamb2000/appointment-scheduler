class ChargesController < ApplicationController

  def create
    @amount = params[:appointment][:price].to_i
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

    redirect_to

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
  end

end
