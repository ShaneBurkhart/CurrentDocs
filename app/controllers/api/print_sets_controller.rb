class Api::PrintSetsController < ApplicationController
  before_filter :user_not_there!
  before_filter :authenticate_user!

  def update
    if user.can? :update, PrintSet
      @print_set = PrintSet.find(params[:id])
      if user.id == @print_set.job.user.id
        @print_set.job.plans.each do |plan|
          psi = nil
          if params[:print_set]
            params[:print_set][:plan_ids].each do |plan_id|
              if plan.id == plan_id.to_i
                psi = @print_set.id
              end
            end
          end
          plan.print_set_id = psi
          plan.save
        end
        if @print_set.save
          render json: @print_set
        else
          render json: {error: "Something went wrong."}
        end
      end
    else
      render_no_permission
    end
  end

  private

    def user
      current_user || User.find_by_authentication_token(params[:token])
    end

    def user_not_there!
      render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token])
    end

    def render_no_permission
      render :json => {error: "You don't have permission to do that"}
    end
end
