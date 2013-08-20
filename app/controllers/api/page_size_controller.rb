class Api::PageSizeController < ApplicationController
	before_filter :user_not_there!

	def page_sizes
		begin
			plan = Plan.find(params[:id])
		rescue
			render :text => "No File Exists!!"
			return
		end
    h = {}
    plan.page_sizes.each do |p|
      key = "#{p[0]} x #{p[1]}"
      if h[key]
        h[key] += 1
      else
        h[key] = 0
      end
    end
    render json: { page_sizes: h.to_json }
	end

	private

    def user_not_there!
      render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token])
    end

end
