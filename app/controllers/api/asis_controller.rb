require 'securerandom'
require "aws-sdk"

class Api::ASIsController < ApplicationController
	before_filter :user_not_there!

  def create
    if user.can? :create, ASI
      @asi_params = params["asi"]
      @job = Job.find(@asi_params["job_id"])

      is_job_owner = user.is_my_job(@job)
      is_job_pm = user.is_project_manager(@job)
      is_assigned = false
      # TODO check for assigned user when rfi exists

      # If creating unlinked asi, we check if is owner or is pm
      if !@asi_params["rfi_id"] and !(is_job_owner or is_job_pm)
        return render json: {}
      end

      # If creating linked asi, we check if is owner or is pm or is assigned
      if @asi_params["rfi_id"] and !(is_job_owner or is_job_pm or is_assigned)
        return render json: {}
      end

      @asi = ASI.new(
        status: "Open",
        subject: @asi_params["subject"],
        notes: @asi_params["notes"],
        job_id: @asi_params["job_id"],
        rfi_id: @asi_params["rfi_id"],
        user_id: user.id,
      )
      attachments = @asi_params["attachment_ids"] || []

      if !@asi.save
        return render json: {}
      end

      attachments.each do |id|
        filename = Redis.current.get("attachments:#{id}")

        attachment = ASIAttachment.create(
          filename: filename,
          s3_path: "attachments/#{id}",
          asi_id: @asi.id,
        )
      end

      # Reload for includes
      @asi = ASI.includes(:attachments).find(@asi.id)

      render json: @asi
    else
      render_no_permission
    end
  end

  def update
    if user.can? :update, ASI
      @asi_params = params[:asi]
      @asi = ASI.find(params[:id])
      @job = @asi.job

      is_job_owner = user.is_my_job(@job)
      is_job_pm = user.is_project_manager(@job)
      is_assigned = false
      # TODO check for assigned to

      # Check if current user is...
      # job owner, job project manager, or assigned to ASI
      if is_job_owner or is_job_pm or is_assigned
				@asi.notes = @asi_params["notes"]
				@asi.subject = @asi_params["subject"]

        if !@asi.save
          return render json: {}
        end

        # Reload for includes
        @asi = ASI.includes(:attachments).find(@asi.id)

        render json: @asi
      else
        render_no_permission
      end
    else
      render_no_permission
    end
  end

  def download_attachment
    @attachment = ASIAttachment.find(params[:id])

    if @attachment
      s3 = AWS::S3.new
      obj = s3.buckets[ENV["AWS_BUCKET"]].objects[@attachment.s3_path];

      send_data obj.read, filename: @attachment.filename, stream: 'true', buffer_size: '4096'
    else
      render_no_permission
    end
  end
end

