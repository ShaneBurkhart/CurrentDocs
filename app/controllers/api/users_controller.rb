class Api::UsersController < ApplicationController
	def index
		render :json => {:users => User.all}
	end

	def show
		render :json => {:user => User.find(params[:id])}
	end
end
