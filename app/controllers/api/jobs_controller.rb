class Api::JobsController < ApplicationController
  before_filter :authenticate_user

  def index
    @jobs = user.jobs

    return not_authorized unless user.can? :read, @jobs

    render json: @jobs
  end

  def show
    @job = Job.find(params[:id])

    return not_authorized unless user.can? :read, @job

    render json: @job
  end

  def create
    return not_authorized unless user.can? :create, Job

    @job = Job.new(name: params["job"]["name"], user_id: user.id)

    if !@job.save
      return error("The job you are creating is invalid.")
    end

    render json: @job
  end

  def update
    @job = Job.find(params[:id])

    return not_authorized unless user.can? :update, @job

    if !@job.update_attributes(params[:job])
      return error("There was a problem when updating your job.")
    end

    render json: @job
  end

  def destroy
    @job = Job.find(params[:id])

    return not_authorized unless user.can? :destroy, @job

    @job.destroy

    render json: {}
  end
end
