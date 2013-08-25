class Api::ChargesController < ApplicationController
  before_filter :user_not_there!

  def create

    @plans = Plan.find(params[:plan_ids])

    # amount is in cents
    @amount = @plans.map(&:calculate_cost).sum

    customer = Stripe::Customer.create(
      :email => user.email,
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "User with ID #{user.id} and email #{user.email} purchased prints of plans with ids: #{params[:plan_ids]}",
      :currency    => 'usd'
    )

    # TODO: Save print in a database or send us an email or send it to print store.

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to root_path # TODO: determine error path
  end

end
