class ShareLinksController < ApplicationController
  before_filter :authenticate_user!, except: [:login]

  def login
    @share_link = ShareLink.where(token: params[:token]).first

    if !@share_link
      return redirect_to new_user_session_path
    end

    session[:share_link_token] = @share_link.token

    redirect_to jobs_path
  end

  def index
    @share_links = current_user.share_links

    authorize! :read_multiple, @share_links

    render :index
  end

  def show
    @share_link = ShareLink.find(params[:id])
    @unshared_jobs = current_user.jobs.order("is_archived ASC").to_a

    # Remove already shared jobs
    @share_link.permissions.job_permissions.each do |job_permission|
      @unshared_jobs.delete(job_permission.job)
    end

    authorize! :read, @share_link

    render :show
  end

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

  def edit
    @share_link = ShareLink.find(params[:id])

    authorize! :update, @share_link

    respond_to do |format|
      format.html{ render :edit }
      format.modal{ render_modal :edit }
    end
  end

  def update
    @share_link = ShareLink.find(params[:id])

    authorize! :update, @share_link

    if !@share_link.update_attributes(params[:share_link])
      return render :edit
    end

    redirect_url = params[:success_redirect_url] || share_links_path

    redirect_to redirect_url
  end

  def should_delete
    @share_link = ShareLink.find(params[:id])

    authorize! :destroy, @share_link

    respond_to do |format|
      format.html
      format.modal{ render_modal :should_delete }
    end
  end

  def destroy
    @share_link = ShareLink.find(params[:id])

    authorize! :destroy, @share_link

    @share_link.destroy

    redirect_to share_links_path
  end
end
