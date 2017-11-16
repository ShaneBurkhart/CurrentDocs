class JobsController < ApplicationController
  def index
    if params[:archived] == "true"
      @jobs = user.archived_jobs
    else
      @jobs = user.open_jobs
    end

    render :index
  end

  def show
    @tab = (params[:tab] || 'plans').downcase
    @job = Job.find(params[:id])

    render :show
  end
end
