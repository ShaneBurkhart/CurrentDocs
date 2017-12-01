class HomeController < ApplicationController
  def index
    redirect_to jobs_path
  end
end
