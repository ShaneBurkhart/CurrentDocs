class Api::DownloadsController < ApplicationController

	def download
		begin
			plan = Plan.find(params[:id])
		rescue
			render :text => "No File Exists!!"
			return
		end
		f = plan.plan.path
		send_file f.to_s, :type => 'application/pdf', :filename => plan.plan_file_name
	end

end
