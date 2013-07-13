class Api::UploadsController < ApplicationController
	before_filter :user_not_there!

	def create
		u = params[:file]
		plan = Plan.find(params[:plan_id])
		plan.plan = u
		if plan.save
			puts "Saved File"
			render :text => "Good one"
		else
			puts "Didn't Saved File"
			render :text => "Bad one"
		end
	end

	private
	def user_not_there!
		render :text => "No user currently signed in" unless user_signed_in?
	end
end
