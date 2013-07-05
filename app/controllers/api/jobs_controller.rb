class Api::JobsController < ApplicationController
  before_filter :user_not_there!

  def index
    if can? :read, Job
      @jobs = current_user.jobs
      @jobs.each do |job|
        job.add_plan_ids!
      end
      render :json => {:jobs => @jobs, :plans => Job.get_plans_from_jobs(@jobs)}
    else
      render :text => "You don't have permission to do that"
    end
  end

  def show
    if can? :read, Job
      @job = Job.find(params[:id])
      if current_user.is_my_job @job
        @job.add_plan_ids!
        render :json => {:job => @job, :plans => @job.plans}
      else
        render :json => {:job => {}}
      end
    else
      render :text => "You don't have permission to do that"
    end
  end

  def create
    if can? :create, @job
      @job = Job.find_or_create_by_name(params["job"]["name"])
      @job.user = current_user unless @job.user
      @job.save
      if @job.user == current_user
        @job.add_plan_ids!
        render :json => {:job => @job, :plans => @job.plans}
      else
        render :text => "You don't have permission to do that"
      end
    else
      render :text => "You don't have permission to do that"
    end
  end

  def update
    if can? :update, Job
      @job = Job.find(params[:id])
      @job.update_attributes(name: params[:job][:name]) unless (!@job || !current_user.is_my_job(@job))
      render :json => {job: @job, plans: @job.plans}
    else
      render :text => "You don't have permission to do that"
    end
  end

  def destroy
    if can? :destroy, Job
      @job = Job.find(params[:id])
      if current_user.is_my_job @job
        if @job
          @job.destroy
          render :json => {job: @job}
        else
          render :text => "No job"
        end
      else
        render :text => "You don't have permission to do that"
      end
    else
      render :text => "You don't have permission to do that"
    end
  end

  private
    def user_not_there!
      render :text => "No user currently signed in" unless user_signed_in?
    end
end
