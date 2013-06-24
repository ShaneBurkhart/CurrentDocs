class Api::UploadsController < ApplicationController
	before_filter :user_not_there!
	
	def create
		begin
			u = params[:file]
			plan = Plan.find(params[:plan_id]).update_attributes(:filename => u.original_filename)
			File.open(Rails.root.join("public", "_files", params[:plan_id]), 'w') do |file|
			  file.write(u.read)
			end
			render :text => "Good one"
		rescue Exception => e
			render :text => e.to_s
		end
	end

	private
    def user_not_there! 
      render :text => "No user currently signed in" unless user_signed_in?
    end
end
