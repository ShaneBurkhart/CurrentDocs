class Api::SharesController < ApplicationController
  before_filter :user_not_there!, except: ["show"]
  before_filter :authenticate_user!, only: ["show"]

  def create
    if user.can? :create, Share
      if user.can_share_job Job.find(params["share"]["job_id"].to_i)
        @user = User.find_by_email params["share"]["email"]
        @contact = Contact.find_or_create_by_user_id_and_contact_id(user.id, @user.id)

        if user == @user
          render json: {error: "You can't share with yourself!"}
          return
        end

        @share = Share.new sharer_id: user.id, job_id: params["share"]["job_id"], user_id: @user.id
        if @share.save
          @user.send_share_notification(@share)
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

        @user = User.find_by(id: ishare[:user_id])
        if @user && @share.new_record?
          @user.send_share_notification(@share)
        end

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
