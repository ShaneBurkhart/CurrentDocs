require 'securerandom'
require "aws-sdk"

class Api::RFIsController < ApplicationController
	before_filter :user_not_there!

  def create
    if user.can? :create, RFI
      @rfi = RFI.new(
        subject: params["rfi"]["subject"],
        notes: params["rfi"]["notes"],
        job_id: params["rfi"]["job_id"],
        user_id: user.id,
      )
      attachments = params["rfi"]["attachment_ids"] || []

      if !@rfi.save
        render json: {}
        return
      end

      attachments.each do |id|
        filename = Redis.current.get("attachments:#{id}")

        attachment = RFIAttachment.create(
          filename: filename,
          s3_path: "attachments/#{id}",
          rfi_id: @rfi.id,
        )
      end

      # Reload for includes
      @rfi = RFI.includes(:asi, :attachments).find(@rfi.id)

      render json: @rfi
    else
      render_no_permission
    end
  end

  def update
    if user.can? :update, Submittal
      @submittal = Submittal.find(params[:id])

      # Check if user can review submittals or is admin
      # Admins need to edit plans after they are accepted
      # Can Review Submittal users edit them to accept
      if user.admin? or user.can_review_submittal
        # Only update plan_id and is_accepted if not already accepted
        if !@submittal.is_accepted
          @submittal.plan_id = params["submittal"]["plan_id"];
          @submittal.is_accepted = params["submittal"]["is_accepted"];
        end
        @submittal.data = params["submittal"]["data"];

        if !@submittal.save
          render json: {}
          return
        end

        if @submittal.is_accepted
          # Update plan to have "Submitted" status when submittal is approved.
          @plan = @submittal.plan
          @plan.status = "Submitted"
          @plan.save
        end

        # Reload for includes
        @submittal = Submittal.includes(:user, :plan, :attachments).find(@submittal.id)

        render json: @submittal
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

  def upload_attachments
    # Upload attachments to s3 and add to redis with expiration. On create
    # submittal, we fetch the attachments from redis from hidden inputs.
    # When record expires, we remove s3 file. Remove record manually when used.
    files = params["files"]
    returnData = { files: [] }

    s3 = AWS::S3.new
    files.each do |key, file|
      uuid = SecureRandom.uuid
      redis_key = "attachments:#{uuid}"
      original_filename = file.original_filename

      obj = s3.buckets[ENV["AWS_BUCKET"]].objects["attachments/#{uuid}"];
      obj.write(file.tempfile)

      # Expire after a day
      Redis.current.setex(redis_key, 24 * 60 * 60, original_filename)

      returnData[:files].push({ id: uuid, original_filename: original_filename })
    end

    render json: returnData
  end

  def download_attachment
    @attachment = Attachment.find(params[:id])

    if @attachment
      s3 = AWS::S3.new
      obj = s3.buckets[ENV["AWS_BUCKET"]].objects[@attachment.s3_path];

      send_data obj.read, filename: @attachment.filename, stream: 'true', buffer_size: '4096'
    else
      render_no_permission
    end
  end
end

