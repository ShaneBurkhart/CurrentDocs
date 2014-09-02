class Api::SharesController < ApplicationController
  before_filter :user_not_there!, except: ["show"]
  before_filter :authenticate_user!, only: ["show"]
=begin
  def show
    if user.can? :update, Share
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
    if user.can? :create, Share
      if user.can_share_job Job.find(params["share"]["job_id"].to_i)
        @user = User.find_by_email params["share"]["email"]
        if @user.nil?
          pass = ('a'..'z').to_a.shuffle[0,8].join
          @user = User.new_guest_user params["share"], pass
          guest = true
          @user.save
        end
        @contact = Contact.find_or_create_by_user_id_and_contact_id(user.id, @user.id)
        if user == @user
          render json: {error: "You can't share with yourself!"}
          return
        end
        @share = Share.new sharer_id: user.id, job_id: params["share"]["job_id"], user_id: @user.id
        if @share.save
          @user.send_share_notification @share, guest, pass
          render json: @share
        else
          render json: {error: "Share already exists!"}
        end
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  def update
    if user.can? :update, Share
      @share = Share.find(params[:id])
      if user.id == @share.sharer_id
        @share.can_reshare = params[:share][:can_reshare] == "true" ? true : false;
        if @share.save
          render json: @share
        else
          render json: {error: "Something went wrong!"}
        end
      end
    else
      render_no_permission
    end
  end
=begin
  def update #accepts shares
    if user.can? :update, Share
      @share = Share.find(params[:id])
      @share.update_attributes(accepted: 1) unless !current_user.is_being_shared(@share)
      render json: @share
    else
      render_no_permission
    end
  end
=end
  def destroy
    if user.can? :destroy, Job
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

  def batch
    @job_id = params[:job_id]
    if(!params[:shares] || params[:shares].length < 1)
      render json: {}
      return
    end
    @current_shares = Share.where(job_id: @job_id)
    params[:shares].each do |i, ishare|
      if(ishare[:checked] && ishare[:checked] != "false")
        @share = Share.find_or_create_by_sharer_id_and_user_id_and_job_id(current_user.id, ishare[:user_id], @job_id)

        @share.can_reshare = ishare[:can_reshare] || false;
        @share.save
      else
        @share = Share.find_by_sharer_id_and_user_id_and_job_id(current_user.id, ishare[:user_id], @job_id)
        @share.destroy if @share
      end
    end
    render json: Share.where(job_id: @job_id)
  end

  private

    def user
      current_user || User.find_by_authentication_token(params[:token])
    end

    def user_not_there!
      render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token])
    end

    def render_no_permission
      render :json => {error: "You don't have permission to do that"}
    end
end
