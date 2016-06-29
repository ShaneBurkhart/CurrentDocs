class Api::UploadsController < ApplicationController
	before_filter :user_not_there!

	def create
		u = params[:file]
		plan = Plan.find(params[:plan_id])
		# puts "plan:\t#{plan.inspect}"
		# puts "u:\t#{u.inspect}"
		if plan.filename
			# Already got a plan, need to make plan file history
			relevant_attr = ['plan_name', 'job_id', 'tab', 'filename', 'plan_num', 'csi']
			new_data = plan.attributes.select{ |key, _| relevant_attr.include? key }
			new_data["plan_id"] = plan.id
			plan_record = PlanRecord.new(new_data)
			plan_record.plan_record = plan.plan
			plan_record.save
		end
		plan.filename = u.original_filename
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
    render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token])
  end
end
