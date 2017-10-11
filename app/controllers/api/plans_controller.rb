class Api::PlansController < ApplicationController
	before_filter :user_not_there!

	def show
		if user.can? :read, Plan
			@plan = Plan.find(params[:id])

			if user.is_my_plan(@plan) || user.is_shared_plan(@plan)
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
      @plan_params = params["plan"]
      # Clean this attr.  No idea why... but not changin' that ish
      @plan_params.delete("updated_at")

			@plan = Plan.new(@plan_params)

			if @plan.save
				render json: @plan
			else
				render json: {}
			end
		else
			render_no_permission
		end
	end

  # Simply update attributes of plan.  No reordering!
	def update
		if user.can? :update, Plan
			@plan = Plan.find(params[:id])
			@plan_params = params["plan"]

			if user.is_my_plan(@plan)
				@plan.plan_name = @plan_params["plan_name"]
        @plan.csi = @plan_params["csi"]
				@plan.status = @plan_params["status"]
				@plan.code = @plan_params["code"]
				@plan.description = @plan_params["description"]
				@plan.tags = @plan_params["tags"]

				if @plan.save
					render json: @plan
				else
					render json: {}
				end
			else
				render_no_permission
			end
		else
			render_no_permission
		end
	end

  # Move plan to after plan with id in plan_id_before
  def reorder
		if user.can? :update, Plan
			@plan = Plan.find(params[:id])
			@plan_id_before = params["plan_id_before"]

			if user.is_my_plan(@plan)
        @plan.move_to_after_plan_id(@plan_id_before)

				if @plan.save
					render json: @plan
				else
					render json: {}
				end
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

			if user.is_my_plan(@plan)
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
		if isRecord? params
			plan = PlanRecord.find(params[:id]).plan
		else
			plan = Plan.find(params[:id])
		end

		if (user && (user.is_my_plan(plan) || user.is_shared_plan(plan))) || (params[:share_token] && ShareLink.find_by_token_and_job_id(params[:share_token], plan.job_id))
			if isRecord? params
				@plan = PlanRecord.find(params[:id])
			else
				@plan = plan
			end
			render 'show_embedded', layout: false and return
		else
			flash[:warning] = "You don't have permission to do that"
			begin
				redirect_to(:back) and return
			rescue ActionController::RedirectBackError
				redirect_to root_path and return
			end
		end
	end

	def plan_records
		@plan = Plan.find(params[:id])
		if user.is_my_plan(@plan)
			render :json => PlanRecord.where(:plan_id => @plan.id).order("created_at DESC")
		elsif user.is_shared_plan(@plan)
			render :json => PlanRecord.where(:plan_id => @plan.id, :archived => false).order("created_at DESC")
		else
			render_no_permission
		end
	end

	private
	def isRecord? params
		return params[:type] == 'plan_record'
	end

end
