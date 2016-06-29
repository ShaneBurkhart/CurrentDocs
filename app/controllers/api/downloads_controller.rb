class Api::DownloadsController < ApplicationController
	before_filter :user_not_there!

	def download
		begin
			plan = Plan.find(params[:id])
		rescue
			render :text => "No File Exists!!"
			return
		end
		if Rails.env.development?
			path = File.join(Rails.root, 'public/system/plans/plans/000/000/', plan.id.to_s, '/original', plan.plan_file_name)
			puts "PATH: #{path}"
			data = open(path)
		else
			data = open(plan.plan.url)
		end
  		send_data data.read, filename: plan.filename, stream: 'true', buffer_size: '4096'
		#f = plan.plan.path
		#send_file f.to_s, :type => 'application/pdf', :filename => plan.filename
	end

	private

    def user_not_there!
      render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token])
    end
end
