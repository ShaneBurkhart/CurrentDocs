class ReportsController < ApplicationController
  before_filter :authenticate_user!

  SHOP_DRAWINGS_PERMISSION = 0b00010

  # Form to selects jobs to show in shop drawings reports
  def shop_drawing_jobs
    # Shop drawings permission
    @shared_jobs = get_active_shared_jobs_with_permissions(SHOP_DRAWINGS_PERMISSION)
    @jobs = user.jobs.where(archived: false) + @shared_jobs

    render :shop_drawing_jobs
  end

  # Shows shop drawing reports for jobs.
  def shop_drawings
    @job_ids = params["job_ids"] || []

    if @job_ids.nil? or @job_ids.count == 0
      # We need job ids for the report
      return redirect_to reports_shop_drawings_jobs_path
    end

    @jobs = Job.where(id: @job_ids, archived: false).select do |job|
      # Make sure is user's job or is shared with permissions
      next user.is_my_job(job) || user.is_shared_job(job, SHOP_DRAWINGS_PERMISSION)
    end

    render :shop_drawings
  end

  private
    def get_active_shared_jobs_with_permissions(permissions)
      shared_jobs = user.shared_jobs.where(archived: false)

      jobs_with_permissions = shared_jobs.select do |job|
        next user.is_shared_job(job, permissions)
      end

      return jobs_with_permissions || []
    end
end
