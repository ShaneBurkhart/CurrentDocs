class PrintsController < ApplicationController
  before_filter :user_not_there!, only: [:purchase]

	def index
	end

  # Page with form to purchase prints
  def purchase
    @plans = Job.find(params[:job_id]).plans
  end

end
