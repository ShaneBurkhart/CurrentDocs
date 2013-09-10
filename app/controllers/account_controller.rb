class AccountController < ApplicationController
  before_filter :authenticate_user!

  def select
    @user = user
  end

  def update
    100.times{puts "AAAAAA"}
    u = user
    u.type = params[:user][:type]
    if u.save
      redirect_to app_path
    else
      notice[:error] = "Not a valid account type"
      render "select"
    end
  end
end
