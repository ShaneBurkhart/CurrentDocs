class UsersController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  def index
    @s = params[:s] || "type"
    @r = params[:r] || false
    @users = User.sorted_by @s
    @users.reverse! if @r == "true"
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    @user.type = params[:user][:type]
    params[:user].delete :type

    if @user.update_attributes params[:user]
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user
      @user.delete
      redirect_to users_path
    end
  end

end
