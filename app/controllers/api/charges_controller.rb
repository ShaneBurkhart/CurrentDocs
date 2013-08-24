class Api::ChargesController < ApplicationController
  before_filter :user_not_there!

  def create

    # TODO: get prints from params
    #prints = Plan.find(params[:blah]) #etc
    @amount = 10 # TODO:  Recalculate amount by sizes here to be secure.  Amount is in cents.

    customer = Stripe::Customer.create(
      :email => user.email,
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "#{user.full_name} purchasing prints x, y, and z.",
      :currency    => 'usd'
    )

    # TODO: Save print in a database or send us an email or send it to print store.

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_path # TODO: determine error path
  end

end
