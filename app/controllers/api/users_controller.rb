class Api::UsersController < ApplicationController
  def index
    render :json => {:users => User.all}
  end

  def show
    render :json => {:user => User.find(params[:id])}
  end

  def contacts
    render json: current_user.contacts
  end


end
