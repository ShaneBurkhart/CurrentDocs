class UsersController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  def index
=begin
      @users = User.all.sort do |x, y|
      return 0 if x.type == y.type
      return -1 if x.viewer?
      return 1 if x.admin?
      return -1 if y.admin?
      return 1 if y.viewer?
    end
=end
    @users = User.all
  end

  def demote
    @user = User.find params[:id]
    if @user.manager?
      @user.type = "Viewer"
      @user.save
    end
    redirect_to users_path
  end
end
