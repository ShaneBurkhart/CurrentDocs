class Api::DownloadsController < ApplicationController

	def download
		begin
			plan = Plan.find(params[:id])
		rescue
			render :text => "No File Exists!!"
			return
		end
		f = Rails.root.join("public", "_files", plan.id.to_s)
		send_file f.to_s, :type => 'application/pdf', :filename => plan.filename
	end

end
