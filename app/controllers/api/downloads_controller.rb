class Api::DownloadsController < ApplicationController
	before_filter :user_not_there!

	def download
		begin
			if isPlanRecord?
				plan = PlanRecord.find(params[:id])
			else
				plan = Plan.find(params[:id])
			end
		rescue
			render :text => "No File Exists!!"
			return
		end

		if Rails.env.development?
			sym = plan.class.name.underscore
			puts "sym: #{sym}"
			rel_path = plan.send(sym).url
			path = File.join(Rails.root, 'public', rel_path)
			
			puts "PATH: #{path}"
			data = open(path)
		else
			if isPlanRecord?
				data = open(plan.plan_record.url)
			else
				data = open(plan.plan.url)
			end
		end
  		send_data data.read, filename: plan.filename, stream: 'true', buffer_size: '4096'
		#f = plan.plan.path
		#send_file f.to_s, :type => 'application/pdf', :filename => plan.filename
	end

	private

    def user_not_there!
      render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token])
    end

    def isPlanRecord?
    	params[:type] == 'plan_record'
    end
end
