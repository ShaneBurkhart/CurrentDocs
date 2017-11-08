require 'securerandom'
require "aws-sdk"

class Api::ASIsController < ApplicationController
	before_filter :user_not_there!

  def create
    if user.can? :create, ASI
      @asi = ASI.new(
        status: "Open",
        subject: params["asi"]["subject"],
        notes: params["asi"]["notes"],
        job_id: params["asi"]["job_id"],
        rfi_id: params["asi"]["rfi_id"],
        user_id: user.id,
      )
      attachments = params["asi"]["attachment_ids"] || []

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
      # TODO check for assigned to

      # Check if current user is...
      # job owner, job project manager, or assigned to ASI
      if is_job_owner or is_job_pm
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

  def destroy
    if user.can? :destroy, Submittal
      @submittal = Submittal.find(params[:id])

      # Check if can review submittal or if the user is admin
      # There's a delete when reviewing and a delete after accepted for admin.
      if user.admin? or user.can_review_submittal
        @submittal.destroy
        render json: @submittal
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

