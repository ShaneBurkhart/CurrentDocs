class Api::JobsController < ApplicationController
  before_filter :authenticate_user!

  def index
    render :json => current_user.jobs
  end

  def show
    begin
      job = current_user.jobs.find(params[:id])
    rescue Exception => e
      job = []
    end
    render :json => job
  end

  def create
    if current_user.can? :create
      Job.create(params["job"])
    end
  end

  def update
    if current_user.can? :update
      Job.update_attributes(params["job"])
    end
  end

  def destroy
    begin
      job = current_user.jobs.find(params[:id])
      if current_user.can? :destroy
        job.destroy
      else
        render :text => "You do not have permission to do that"
      end
    rescue Exception => e
    end
  end
end
