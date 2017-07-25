class Api::SubmittalsController < ApplicationController
	before_filter :user_not_there!

  def index
    if user.can? :read, Submittal
      @submittals = Submittal.where(plan_id: params[:plan_id], is_accepted: true).includes(:user).order("created_at DESC")

      render json: @submittals
    else
      render_no_permission
    end
  end

  def create
    if user.can? :create, Submittal
      @submittal = Submittal.new(
        data: params["submittal"]["data"],
        job_id: params["submittal"]["job_id"],
        user_id: user.id,
      )

      if !@submittal.save
        render json: {}
        return
      end

      # Reload for includes
      @submittal = Submittal.includes(:user).find(@submittal.id)

      render json: @submittal
    else
      render_no_permission
    end
  end

  def update
    if user.can? :update, Submittal
      @submittal = Submittal.find(params[:id])

      # Check if submittal belongs to a job the user owns
      if @submittal && @submittal.job.user_id == user.id
        @submittal.is_accepted = params["submittal"]["is_accepted"];
        @submittal.plan_id = params["submittal"]["plan_id"];
        @submittal.data = params["submittal"]["data"];

        if !@submittal.save
          render json: {}
          return
        end

        # Reload for includes
        @submittal = Submittal.includes(:user).find(@submittal.id)

        render json: @submittal
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end
end
