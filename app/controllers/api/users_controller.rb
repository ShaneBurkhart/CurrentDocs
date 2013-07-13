class Api::UsersController < ApplicationController
	def index
		render :json => {:users => User.all}
	end

	def show
		render :json => {:user => User.find(params[:id])}
	end

	def autocomplete
		users = Viewer.where("email LIKE :starts", starts: "#{params[:starts_with]}%").limit(params[:num].to_i/2)
		users = Manager.where("email LIKE :starts", starts: "#{params[:starts_with]}%").limit(params[:num].to_i/2)
		render json: users
	end


end
