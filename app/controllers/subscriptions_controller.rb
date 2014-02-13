class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = user
  end

  def update
    if user.type.nil?
      flash[:notice] = "Thanks for signing up!"
      user.type = params[:user][:type]
      user.save
      redirect_to app_path
      return
    end
    user.cancelled = true if params[:user][:type] == "Viewer"
    user.cancel_subscription if user.manager? and params[:user][:type] == "Viewer"
    if user.save
      if user.manager?
        flash[:notice] = "You will be a viewer when your subscription ends."
      else
        flash[:notice] = "Successfully upgraded your account!"
      end
      redirect_to app_path
    else
      account_type_error
    end
  end

  def billing
    @user = user
  end

  def processing
    @user = user
    if(params["user"]["stripe_customer_id"])
      if(@user.subscribe(params["user"]["stripe_customer_id"]))
        redirect_to app_path, flash: {notice: "Success! Thanks for signing up!"}
      else
        flash[:error] = "There was an error."
        render billing
      end
    else
      flash[:error] = "Please enter your credit card information."
      render "billing"
    end
  end

    private

    def account_type_error
      flash[:error] = "Not a valid account type"
      render "show"
    end

    def billing_error
      flash[:error] = "There was an error with your card.  Please make sure you entered it correctly"
      render "billing"
    end
end
