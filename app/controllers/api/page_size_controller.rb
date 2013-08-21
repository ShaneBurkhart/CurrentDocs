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
      width = p[0] % 1 == 0 ? p[0].to_i : p[0]
      height = p[1] % 1 == 0 ? p[1].to_i : p[1]
      key = "#{width}\" x #{height}\""
      if h[key]
        h[key] += 1
      else
        h[key] = 0
      end
    end
    render json: { page_sizes: h }
	end

	private

    def user_not_there!
      render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token])
    end

end
