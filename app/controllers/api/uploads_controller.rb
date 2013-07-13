class Api::UploadsController < ApplicationController
	before_filter :user_not_there!

	def create
		u = params[:file]
		plan = Plan.find(params[:plan_id])
		plan.update_attributes(:filename => u.original_filename)
		File.open(Rails.root.join("public", "_files", plan.id.to_s), 'wb') do |file|
			file.write(u.read)
			file.close
		end
		puts "Saved File"
		render :text => "Good one"
	end

	private
	def user_not_there!
		render :text => "No user currently signed in" unless user_signed_in?
	end
end
