class Api::PlansController < ApplicationController
	before_filter :user_not_there!

  def index
    if can? :read, Plan
      @plans = Job.get_plans_from_jobs current_user.jobs
      render :json => {:plans => @plans}
    else
      render_no_permission
    end
  end

  def show
    if can? :read, Plan
      @plan = Plan.find(params[:id])
      if @plan.job.user.id == current_user.id
        render :json => {:plan => @plan}
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  def create
    if can? :create, Plan
      @plan = Plan.find_or_create_by_plan_name(params["plan"][:plan_name])
      if !@plan.id
        params["plan"].delete "updated_at"
        params["plan"][:plan_num] = Plan.next_plan_num(params["plan"][:job_id])
        @plan.update_attributes(params["plan"])
      end
      render :json => {:plan => @plan}
    else
      render_no_permission
    end
  end

  def update
    if can? :update, Plan
      @plan = Plan.find(params[:id])
      if @plan.job.user.id == current_user.id
        if !params["plan"]["plan_num"].nil? && params["plan"]["plan_num"].is_a?(Numeric)
          @plan.set_plan_num params["plan"]["plan_num"]
          params["plan"].delete "plan_num"
        end
        params["plan"].delete "updated_at"
        @plan.update_attributes(params["plan"])
        render :json => {:plan => @plan}
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  def destroy
    if can? :destroy, Plan
      @plan = Plan.find(params[:id])
      if @plan.job.user.id == current_user.id
        @plan.destroy
        render json: {plan: @plan}
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
