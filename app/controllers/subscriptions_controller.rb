class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def show
    redirect_to edit_user_registration_path if !user.type.nil?
    @user = user
  end

  def update
    if params[:user][:type] == "Viewer"
      user.type = params[:user][:type]
      if user.save
        user.cancel_subscription
        redirect_to app_path
      else
        account_type_error
      end
    else
      account_type_error
    end
  end

  def billing
    redirect_to edit_user_registration_path if user.type == "Manager"
    @subscription = user.subscription || Subscription.new
  end

  def create
    @subscription = Subscription.new params[:subscription]
    @subscription.stripe_card_token = params[:stripeToken]
    @subscription.user_id = user.id

    if @subscription.save_with_stripe
      user.type = "Manager"
      user.save
      flash[:notice] = "You are now a Manager! Thank you for subscribing!"
      redirect_to app_path
    else
      billing_error
    end
  end

    rescue_from Stripe::CardError do |e|
      flash[:error] = e.message
      render "billing"
    end

  private

    def account_type_error
      flash[:error] = "Not a valid account type"
      render "select"
    end

    def billing_error
      flash[:error] = "There was an error with your card.  Please make sure you entered it correctly"
      render "billing"
    end
end
