class AppController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_user_account!
#  before_filter :check_subscription!

	def index

	end
end
