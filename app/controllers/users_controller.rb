class UsersController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  def index
    @s = params[:s] || "type"
    @r = params[:r] || false
    @users = User.sorted_by @s
    @users.reverse! if @r == "true"
  end

  def demote
    @user = User.find params[:id]
    if @user.manager?
      @user.type = "Viewer"
      @user.expired = false
      @user.save
    end
    redirect_to users_path
  end

  def destroy
    @user = User.find(params[:id])
    if @user
      @user.delete
      redirect_to users_path
    end
  end

end
