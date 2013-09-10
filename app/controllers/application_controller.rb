class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def after_sign_in_path_for(resource_or_scope)
  	session[:user_return_to] || app_path
  end

  def user_not_there!
    render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token])
  end

  def check_user_account!
    redirect_to account_path if user.type.blank?
  end

  def user
    current_user || User.find_by_authentication_token(params[:token])
  end

end
