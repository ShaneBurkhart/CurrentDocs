class Api::JobsController < ApplicationController
  before_filter :user_not_there!

  def index
    if can? :read, Job
      @jobs = current_user.jobs + current_user.shared_jobs
      render json: @jobs
    else
      render_no_permission
    end
  end

  def show
    if can? :read, Job
      @job = Job.find(params[:id])
      if current_user.is_my_job(@job) || current_user.is_shared_job(@job)
        render json: @job
      else
        render json: {job: {}}
      end
    else
      render_no_permission
    end
  end

  def create
    if can? :create, Job
      @job = Job.new(name: params["job"]["name"], user_id: current_user.id)
      if !@job.save
        render json: @job
        return
      end
      if
        render json: @job
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  def update
    if can? :update, Job
      @job = Job.find(params[:id])
      @job.update_attributes(name: params[:job][:name]) unless (!@job || !current_user.is_my_job(@job))
      render json: @job
    else
      render_no_permission
    end
  end

  def destroy
    if can? :destroy, Job
      @job = Job.find(params[:id])
      if current_user.is_my_job @job
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
    def user_not_there!
      render text: "No user signed in" unless user_signed_in?
    end

    def render_no_permission
      render :text => "You don't have permission to do that"
    end
end
