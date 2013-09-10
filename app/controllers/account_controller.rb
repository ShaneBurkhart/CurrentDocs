class AccountController < ApplicationController
  before_filter :authenticate_user!

  def select
    @user = user
  end

  def update
    u = user
    u.type = params[:user][:type]
    if u.save
      if u.type == "Viewer"
        flash[:notice] = "You are now a Viewer."
      else
        flash[:notice] = "You are now a Manager. Thank you for subscribing!"
      end
      redirect_to app_path
    else
      flash[:error] = "Not a valid account type"
      render "select"
    end
  end
end
