class AccountController < ApplicationController
  before_filter :authenticate_user!

  def select
    redirect_to edit_user_registration_path if !user.type.nil?
    @user = user
  end

  def update
    u = user
    if params[:user][:type] == "Viewer"
      u.type = params[:user][:type]
      if u.save
        if u.type == "Viewer"
          flash[:notice] = "You are now a Viewer!"
        else
          flash[:notice] = "You are now a Manager! Thank you for subscribing!"
        end
        redirect_to app_path
      else
        flash[:error] = "Not a valid account type"
        render "select"
      end
    else
      flash[:error] = "Not a valid account type"
      render "select"
    end
  end

  def billing
    redirect_to edit_user_registration_path if user.type == "Manager"
  end

  def update_billing
    if params["stripeToken"].blank?
      flash[:error] = "You must enter billing information."
      render "billing"
      return
    end
    customer = Stripe::Customer.create(
      :email => user.email,
      :card  => params[:stripeToken]
    )

    if customer
      user.stripe_customer_id = customer.id
      user.type = "Manager"
      if user.save
        flash[:notice] = "You are now a Manager! Thank you for subscribing!"
        redirect_to app_path
      else
        flash[:error] = "There was an error with your card.  Please make sure you entered it correctly"
        render "billing"
      end
    else
      flash[:error] = "There was an error with your card.  Please make sure you entered it correctly"
      render "billing"
    end

  end

    rescue_from Stripe::CardError do |e|
      flash[:error] = e.message
      render "billing"
    end
end
