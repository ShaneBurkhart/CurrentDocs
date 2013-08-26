class Api::PageSizeController < ApplicationController
	before_filter :user_not_there!

	def page_sizes
    plan_ids = params[:plan_ids]
    price = 0
    plan_ids.each do |plan_id|
      begin
        p = Plan.find(plan_id)
        price += p.calculate_cost
      rescue
        render json: {error: "A file doesn't exist"}, status: 422
      end
    end
    render json: { price: price }
	end

end
