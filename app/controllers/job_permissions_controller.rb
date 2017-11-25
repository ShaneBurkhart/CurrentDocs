class JobPermissionsController < ApplicationController
  def edit
    @job_permission = JobPermission.find(params[:id])
    @share_link = @job_permission.permissions.authenticatable

    authorize! :update, @job_permission

    render :edit
  end

  def update
    @job_permission = JobPermission.find(params[:id])

    authorize! :update, @job_permission
  end
end
