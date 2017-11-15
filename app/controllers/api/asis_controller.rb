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

      # If creating unlinked asi, we check if is owner or is pm
      if !@asi_params["rfi_id"] and !(is_job_owner or is_job_pm)
        return render json: {}
      end

      # If creating linked asi, we check if is owner or is pm or is assigned
      if @asi_params["rfi_id"]
        @rfi = RFI.find(@asi_params["rfi_id"])
        is_assigned = user.is_assigned_to_me(@rfi)

        if !(is_job_owner or is_job_pm or is_assigned)
          return render json: {}
        end
      end

      @asi = ASI.new(
        status: "Open",
        plan_sheets_affected: @asi_params["plan_sheets_affected"],
        in_addendum: @asi_params["in_addendum"],
        subject: @asi_params["subject"],
        notes: @asi_params["notes"],
        job_id: @asi_params["job_id"],
        rfi_id: @asi_params["rfi_id"],
        user_id: user.id,
      )
      attachments = @asi_params["updated_attachments"] || {}

      if !@asi.save
        return render json: {}
      end

      attachments.each do |i, a|
        upload_id = a["upload_id"]
        filename = Redis.current.get("attachments:#{upload_id}")

        attachment = ASIAttachment.create(
          filename: filename,
          description: a["description"],
          s3_path: "attachments/#{upload_id}",
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
    @asi_params = params[:asi]
    @asi = ASI.find(params[:id])
    @job = @asi.job

    is_job_owner = user.is_my_job(@job)
    is_job_pm = user.is_project_manager(@job)
    is_assigned = user.is_assigned_to_me(@asi)

    # Check if current user is...
    # job owner, job project manager, or assigned to ASI
    if is_job_owner or is_job_pm or is_assigned
      @asi.notes = @asi_params["notes"]
      @asi.subject = @asi_params["subject"]
      @asi.plan_sheets_affected = @asi_params["plan_sheets_affected"]
      @asi.in_addendum = @asi_params["in_addendum"]
      @asi.date_submitted = @asi_params["date_submitted"]
      @asi.status = @asi_params["status"]

      if !@asi.save
        return render json: {}
      end

      attachments = @asi_params["updated_attachments"] || {}

      attachments.each do |i, a|
        id = a["id"]
        upload_id = a["upload_id"]

        if upload_id
          # New attachment
          filename = Redis.current.get("attachments:#{upload_id}")

          attachment = ASIAttachment.create(
            filename: filename,
            description: a["description"],
            s3_path: "attachments/#{upload_id}",
            asi_id: @asi.id,
          )
        else
          # Not a new attachment.  We are updating the description
          asiAttachment = ASIAttachment.find(id)
          asiAttachment.description = a["description"]
          asiAttachment.save
        end
      end


      # Reload for includes
      @asi = ASI.includes(:attachments).find(@asi.id)

      render json: @asi
    else
      render_no_permission
    end
  end

  def assign
    @asi = ASI.find(params[:id])
    @job = @asi.job

    is_job_owner = user.is_my_job(@job)
    is_job_pm = user.is_project_manager(@job)

    if is_job_owner or is_job_pm
      @asi.assigned_user_id = params["assign_to_user_id"]

      if !@asi.save
        return render json: {}
      end

      render json: @asi
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

