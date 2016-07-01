class Api::PlansController < ApplicationController
	before_filter :user_not_there!

  def show
    if user.can? :read, Plan
      @plan = Plan.find(params[:id])
      if current_user.is_my_plan(@plan) || current_user.is_shared_plan(@plan)
        render json: @plan
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  def create
    if user.can? :create, Plan
      params["plan"].delete "updated_at"
			next_plan_num = Plan.next_plan_num(
        params["plan"]["job_id"],
        params["plan"]["tab"]
      )
			params["plan"]["plan_num"] = next_plan_num

			puts "The current next #{params['plan']['tab']} num is #{next_plan_num}"
      @plan = Plan.new params["plan"]
			puts "PLAN ERRORS: #{@plan.errors.full_messages}"

      if @plan.save
        render json: @plan
      else
        render json: {}
      end
    else
      render_no_permission
    end
  end

  def update
    if user.can? :update, Plan
      @plan = Plan.find(params[:id])
      if current_user.is_my_plan @plan
        if !params["plan"]["plan_num"].nil? && params["plan"]["plan_num"].to_i.is_a?(Numeric)
					@plan.update_attribute(:plan_name, params["plan"]["plan_name"])
          csi = params["plan"]["csi"]
          if csi == 0 || csi == nil || csi == ""
            @plan.update_attribute(:csi, nil)
          else
            @plan.update_attribute(:csi, csi.to_i)
          end
					@plan.set_plan_num params["plan"]["plan_num"].to_i
					@plan.update_attribute(:status, params["plan"]["status"])
          params["plan"].delete "plan_num"
        end
        params["plan"].delete "updated_at"
        render json: @plan
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  def destroy
    if user.can? :destroy, Plan
      @plan = Plan.find(params[:id])
      if current_user.is_my_plan @plan
        @plan.destroy
        render json: {}
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  def show_embedded
    @plan = Plan.find(params[:id])
    if user.is_my_plan(@plan) || user.is_shared_plan(@plan)
      render 'show_embedded', layout: false and return
    end
    render_no_permission
  end

  private

end
