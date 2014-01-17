class UsersController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  def index
    @users = User.all.sort_by{ |x| 3 - sort_param(x) }
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

  private

    def sort_param(x)
      return 0 if x.type.nil?
      return 1 if x.viewer?
      return 2 if x.manager?
      return 3 if x.admin?
      return 0
    end
end
