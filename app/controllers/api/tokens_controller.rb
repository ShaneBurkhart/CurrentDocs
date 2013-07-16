class Api::TokensController < ApplicationController

	def create
		@user = User.find_by_email params[:email]
		if @user.nil?
			render json: {message: "Invalid email or password"}
		else
			if @user.valid_password? params[:password]
				render json: {token: @user.authentication_token}
			else
				render json: {message: "Invalid email or password"}
			end
		end
	end

end
