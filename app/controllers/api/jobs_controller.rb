class Api::JobsController < ApplicationController
  before_filter :user_not_there!

  def index
    @jobs = current_user.jobs
    @jobs.each do |job|
      plan_ids! job
    end
    render :json => {:jobs => @jobs, :plans => plans_from_jobs_array(@jobs)}
  end

  def show
    begin
      job = current_user.jobs.find(params[:id])
      plan_ids! job
    rescue Exception => e
      job = []
    end
    render :json => {:job => job, :plans => job.plans}
  end

  def create
    if can? :create, @job
      @job = Job.create(:name => params["job"]["name"], :user_id => current_user.id)
      plan_ids! @job
      render :json => {:job => @job}
    else
      render :text => "You don't have permission to do that"
    end
  end

  def update
    @job = Job.find(params[:id])
    if can? :update, Job
      @job.update_attributes(name: params[:job][:name]) unless !@job
    end
    render :json => {:job => @job}
  end

  def destroy
    begin
      job = current_user.jobs.find(params[:id])
      if !job
        render :text => "No job with that index"
      end
      if can? :destroy, Job
        job.destroy
        render :json => nil, :status => :ok
      else
        render :text => "You do not have permission to do that"
      end
    rescue Exception => e
      render :text => e.to_s, :status => :ok
    end
  end

  private

    def plans_from_jobs_array(jobs)
      plans = []
      jobs.each do |job|
        plans += job.plans
      end
      plans
    end

    def plan_ids!(job)
      ids = []
      job.plans.each do |plan|
        ids[plan.id]
      end
      job[:plan_ids] = ids
    end

    def user_not_there!
      render :text => "No user currently signed in" unless user_signed_in?
    end
end
