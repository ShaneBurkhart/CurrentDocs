class Api::SharesController < ApplicationController
  before_filter :user_not_there!, except: ["show"]
  before_filter :authenticate_user!, only: ["show"]
=begin
  def show
    if can? :update, Share
      if params["token"] && current_user.is_my_token(params["token"])
        @share = Share.find_by_token(params["token"])
        @share.update_attributes(accepted: 1) unless !current_user.is_being_shared(@share)
        flash[:notice] = "You have accepted #{@share.job.name}!"
        redirect_to app_path
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end
=end
  def create
    if can? :create, Share
      if current_user.is_my_job Job.find(params["share"]["job_id"].to_i)
        @user = User.find_by_email params["share"]["email"]
        if @user.nil?
          @user = User.new_guest_user params["share"]
          guest = true
          @user.save
        end
        if current_user == @user
          render json: {error: "You can't share with yourself!"}
          return
        end
        @share = Share.new job_id: params["share"]["job_id"], user_id: @user.id
        if @share.save
          @user.send_share_notification @share, guest
        end
        render json: @share
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end
=begin
  def update #accepts shares
    if can? :update, Share
      @share = Share.find(params[:id])
      @share.update_attributes(accepted: 1) unless !current_user.is_being_shared(@share)
      render json: @share
    else
      render_no_permission
    end
  end
=end
  def destroy
    if can? :destroy, Job
      @share = Share.find(params[:id])
      if current_user.is_my_share @share
        @share.destroy
        render json: {}
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  private

    def user_not_there!
      render json: {error: "No user signed in"} unless user_signed_in?
    end

    def render_no_permission
      render :json => {error: "You don't have permission to do that"}
    end
end
