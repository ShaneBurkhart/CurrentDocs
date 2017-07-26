require 'securerandom'
require "aws-sdk"

class Api::SubmittalsController < ApplicationController
	before_filter :user_not_there!

  def index
    if user.can? :read, Submittal
      @submittals = Submittal.where(plan_id: params[:plan_id], is_accepted: true).includes(:user, :attachments).order("created_at DESC")

      render json: @submittals
    else
      render_no_permission
    end
  end

  def create
    if user.can? :create, Submittal
      @submittal = Submittal.new(
        data: params["submittal"]["data"],
        job_id: params["submittal"]["job_id"],
        user_id: user.id,
      )
      attachments = params["submittal"]["attachment_ids"] || []

      if !@submittal.save
        render json: {}
        return
      end

      attachments.each do |id|
        filename = Redis.current.get("attachments:#{id}")

        attachment = Attachment.create(
          filename: filename,
          s3_path: "attachments/#{id}",
          submittal_id: @submittal.id,
        )
        puts attachment
      end

      # Reload for includes
      @submittal = Submittal.includes(:user, :attachments).find(@submittal.id)

      # Send notification to owner
      UserMailer.submittal_notification(@submittal).deliver

      render json: @submittal
    else
      render_no_permission
    end
  end

  def update
    if user.can? :update, Submittal
      @submittal = Submittal.find(params[:id])

      # Check if submittal belongs to a job the user owns
      if @submittal && @submittal.job.user_id == user.id
        @submittal.is_accepted = params["submittal"]["is_accepted"];
        @submittal.plan_id = params["submittal"]["plan_id"];
        @submittal.data = params["submittal"]["data"];

        if !@submittal.save
          render json: {}
          return
        end

        # Reload for includes
        @submittal = Submittal.includes(:user, :attachments).find(@submittal.id)

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
