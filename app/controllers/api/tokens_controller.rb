class Api::TokensController < ApplicationController

  def create
    @user = User.find_by_email params[:email]
    if @user.nil?
      render json: {message: "Invalid email or password"}
    else
      if @user.valid_password? params[:password]
          if !@user.
        render json: {token: @user.authentication_token}
      else
        render json: {message: "Invalid email or password"}
      end
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless self.class.unscoped.where(authentication_token: token).first
    end
  end

end
