class Api::JobsController < ApplicationController
  before_filter :user_not_there!

  def index
    @jobs = current_user.jobs
    @jobs.each do |job|
      job.add_plan_ids!
    end
    render :json => {:jobs => @jobs, :plans => Job.get_plans_from_jobs(@jobs)}
  end

  def show
    @job = Job.find(params[:id])
    if current_user.is_my_job @job
      @job.add_plan_ids!
      render :json => {:job => @job, :plans => @job.plans}
    else
      render :json => {:job => {}}
    end
  end

  def create
    if can? :create, @job
      @job = Job.find_or_create(:name => params["job"]["name"], :user_id => current_user.id)
      @job.add_plan_ids!
      render :json => {:job => @job, :plans => @job.plans}
    else
      render :text => "You don't have permission to do that"
    end
  end

  def update
    if can? :update, Job
      @job = Job.find(params[:id])
      @job.update_attributes(name: params[:job][:name])
      unless !@job || !current_user.is_my_job @job
      render :json => {:job => @job}
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
