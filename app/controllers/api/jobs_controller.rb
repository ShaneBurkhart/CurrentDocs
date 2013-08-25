class Api::JobsController < ApplicationController
  before_filter :user_not_there!

  def index
    if user.can? :read, Job
      @jobs = user.jobs + user.shared_jobs
      render json: @jobs
    else
      render_no_permission
    end
  end

  def show
    if user.can? :read, Job
      @job = Job.find(params[:id])
      if user.is_my_job(@job) || user.is_shared_job(@job)
        render json: @job
      else
        render json: {job: {}}
      end
    else
      render_no_permission
    end
  end

  def create
    if user.can? :create, Job
      @job = Job.new(name: params["job"]["name"], user_id: user.id)
      if !@job.save
        render json: {}
        return
      end
      render json: @job
    else
      render_no_permission
    end
  end

  def update
    if user.can? :update, Job
      @job = Job.find(params[:id])
      if @job && user.is_my_job(@job)
        @job.name = params[:job][:name]
        @job.update_attributes params[:job]
        render json: @job
      else
        render json: @job
      end
    else
      render_no_permission
    end
  end

  def destroy
    if user.can? user, :destroy, Job
      @job = Job.find(params[:id])
      if user.is_my_job @job
        if @job
          @job.destroy
          render json: {}
        else
          render :text => "No job"
        end
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  private


    def render_no_permission
      render :text => "You don't have permission to do that"
    end
end
