class AppController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_user_account!

	def index

	end
end
