class Api::PlansController < ApplicationController
	before_filter :user_not_there!

  def index
    begin
      plans = current_user.jobs.find(params[:job_id]).plans
    rescue
      plans = []
    end
    render :json => {:plans => plans}
  end

  def show
    begin
      plan = find_plan(params[:id])
    rescue Exception => e
      plan = {}
    end
    render :json => {:plan => plan}
  end

  def create
    if can? :create, Plan
      params["plan"][:plan_num] = next_plan_num(params["plan"][:job_id])
      plan = Plan.create(params["plan"])
      render :json => {:plan => plan}
    else
      render :text => "You don't have permission to do that"
    end
  end

  def update
    if can? :update, Plan
      plan = Plan.create(params["plan"])
      render :json => {:plan => plan}
    else
      render :text => "You don't have permission to do that"
    end
  end

  def destroy
    begin
      plan = Plan.find(params[:id])
      if !plan
        render :text => "No job with that index"
      end
      #Check to make sure its the users
      if plan.job.user.id != current_user.id
        render :text => "You do not have permission to do that"
      end
      if can? :destroy, Plan
        plan.destroy
        render :json => nil, :status => :ok
      else
        render :text => "You do not have permission to do that"
      end
    rescue Exception => e
      render :text => e.to_s, :status => :ok
    end
  end

  private

    def next_plan_num(job_id)
      greatest = 0
      begin
        Job.find(job_id).plans.each do |plan|
          if plan.plan_num >= greatest
            greatest = plan.plan_num
          end
        end
        return greatest + 1
      rescue
        return greatest
      end
    end

    def find_plan(plan_id)
      current_user.jobs.each do |job|
        plan = job.plans.find(plan_id)
        if(plan)
          return plan
        end
      end
      return {}
    end

    def user_not_there! 
      render :text => "No user currently signed in" unless user_signed_in?
    end
end
