require 'colorize'
class Api::UploadsController < ApplicationController
	before_filter :user_not_there!

	def create
		new_file = params[:file]
		plan = Plan.find(params[:plan_id])
		if plan.filename
			# Already got a plan, need to make plan file history
			# relevant_attr = ['plan_name', 'job_id', 'tab', 'filename', 'plan_num', 'csi']
			# new_data = plan.attributes.select{ |key, _| relevant_attr.include? key }

			# new_data["plan_id"] = plan.id
			plan_record = PlanRecord.create(:plan_id=>plan.id, :filename=>plan.filename, :plan_updated_at=>Time.now, :plan_record_file_name=>plan.plan_file_name, :plan_record=>plan.plan)
			# plan_record.plan_record = plan.plan
			# plan_record.save
			# plan_record.plan_record.reprocess!
		end

		plan.plan_updated_at = Time.now
		plan.filename = new_file.original_filename
		plan.plan = new_file

		if plan.save
			# Create event that a user has uploaded to a plan.
			Event.create(user_id:user.id, target_type:NOTIF_TARGET_TYPE[:plan], target_id: plan.id, target_action:NOTIF_ACTIONS[:upload])
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
