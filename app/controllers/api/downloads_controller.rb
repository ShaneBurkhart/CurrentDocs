class Api::DownloadsController < ApplicationController

	def download
		begin
			plan = Plan.find(params[:id])
		rescue
			render :text => "No File Exists!!"
			return
		end
		data = open(plan.plan.url)
  	send_data data.read, filename: plan.filename, type: "application/pdf", disposition: 'inline', stream: 'true', buffer_size: '4096'
		#f = plan.plan.path
		#send_file f.to_s, :type => 'application/pdf', :filename => plan.filename
	end

end
