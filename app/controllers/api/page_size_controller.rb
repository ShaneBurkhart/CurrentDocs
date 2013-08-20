class Api::PageSizeController < ApplicationController
	before_filter :user_not_there!

	def page_sizes
		begin
			plan = Plan.find(params[:id])
		rescue
			render :text => "No File Exists!!"
			return
		end
    render json: { page_sizes: plan.page_sizes.to_json }
	end

	private

    def user_not_there!
      render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token])
    end

end
