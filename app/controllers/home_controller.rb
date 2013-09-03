class HomeController < ApplicationController
  before_filter :go_to_app?

  def index
    @user = User.new
  end

  private

    def go_to_app?
      redirect_to app_path if current_user
    end
end
