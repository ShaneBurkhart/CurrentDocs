class JobsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @is_archived = params[:archived] == "true"

    if @is_archived
      @jobs = user.archived_jobs || []
    else
      @jobs = user.open_jobs || []
    end

    authorize! :read_multiple, @jobs

    render :index
  end

  def show
    @tab = (params[:tab] || 'plans').downcase
    @job = Job.find(params[:id])

    authorize! :read, @job

    render :show
  end

  def new
    @job = Job.new

    authorize! :create, Job

    respond_to do |format|
      format.html
      format.modal { render :new, formats: [:html], layout: false }
    end
  end

  def create
    @job = Job.new(params[:job])
    @job.user_id = current_user.id

    authorize! :create, Job

    if !@job.save
      return render :new
    end

    redirect_to jobs_path
  end

  def edit
    @job = Job.find(params[:id])

    authorize! :update, @job

    respond_to do |format|
      format.html{ render :new }
      format.modal{ render :new, formats: [:html], layout: false }
    end
  end

  def update
    @job = Job.find(params[:id])

    authorize! :update, @job

    if !@job.update_attributes(params[:job])
      return render :new
    end

    redirect_url = params[:success_redirect_url] || jobs_path(archived: @job.archived)

    redirect_to redirect_url
  end

  def should_delete
    @job = Job.find(params[:id])

    authorize! :delete, @job

    respond_to do |format|
      format.html
      format.modal{ render :should_delete, formats: [:html], layout: false }
    end
  end

  def destroy
    @job = Job.find(params[:id])

    authorize! :destroy, @job

    @job.destroy

    redirect_to jobs_path
  end
end
