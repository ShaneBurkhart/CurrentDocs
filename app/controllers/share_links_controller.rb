class ShareLinksController < ApplicationController
  before_filter :authenticate_user!, except: [:login]

  def new
    @share_link = ShareLink.new
    @job = Job.find_by_id(params[:job_id])

    @share_link.user_id = current_user.id

    authorize! :create, @share_link

    render :new
  end

  def create
    @job = Job.find_by_id(params[:job_id])
    @share_link = ShareLink.find_by_id(params[:share_link_id])

    # If share link doesn't already exist, create it
    if @share_link.nil?
      @share_link = ShareLink.new(params[:share_link])
      @share_link.user_id = current_user.id

      authorize! :create, @share_link

      if !@share_link.save
        return render :new
      end
    end

    # Share job and redirect to edit permissions for job.
    if !@job.nil?
      authorize! :share, @job

      @job_permission = @share_link.permissions.find_or_create_job_permission(@job)

      return redirect_to edit_job_permission_path(@job_permission)
    end

    redirect_to share_link_path(@share_link)
  end

  def login
    @share_link = ShareLink.where(token: params[:token]).first

    if !@share_link
      return redirect_to new_user_session_path
    end

    session[:share_link_token] = @share_link.token

    redirect_to jobs_path
  end
end
