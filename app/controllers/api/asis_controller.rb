require 'securerandom'
require "aws-sdk"

class Api::ASIsController < ApplicationController
	before_filter :user_not_there!

  def create
    if user.can? :create, ASI
      @asi = ASI.new(
        subject: params["asi"]["subject"],
        notes: params["asi"]["notes"],
        job_id: params["asi"]["job_id"],
        user_id: user.id,
      )
      attachments = params["asi"]["attachment_ids"] || []

      if !@asi.save
        render json: {}
        return
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

