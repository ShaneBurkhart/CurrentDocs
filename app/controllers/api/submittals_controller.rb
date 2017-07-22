class Api::SubmittalsController < ApplicationController
	before_filter :user_not_there!

  def index
    if user.can? :read, Submittal
      @submittals = Submittal.where(plan_id: params[:plan_id]).includes(:user).order("created_at DESC")

      # Weird af, but idk what else to do to not have [{submittals: <object>},...]
      render json: { submittals: @submittals }, root: false
    else
      render_no_permission
    end
  end
end
