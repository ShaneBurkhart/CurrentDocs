require "aws-sdk"

class Api::TroubleshootController < ApplicationController
	before_filter :user_not_there!

  # Send a troubleshoot email with message and links to files.
  def create
    s3 = Aws::S3::Client.new
    message = params["message"]
    attachment_ids = params["attachment_ids"] || []
    url = params["url"]
    user_agent = params["user_agent"]

    # Move files to troubleshoot bucket
    # Set content disposition to download as filename
    attachments = attachment_ids.map do |id|
      filename = Redis.current.get("attachments:#{id}")

      s3.copy_object(
        bucket: ENV["AWS_BUCKET"],
        copy_source: "#{ENV["AWS_BUCKET"]}/attachments/#{id}",
        key: "troubleshoot/#{id}",
        acl: "public-read",
        content_disposition: filename,
      )

      s3.delete_object(
        bucket: ENV["AWS_BUCKET"],
        key: "attachments/#{id}",
      )

      next {
        id: id,
        filename: filename,
        url: "https://s3.amazonaws.com/#{ENV['AWS_BUCKET']}/troubleshoot/#{id}"
      }
    end

    TroubleshootMailer.issue_notification(user, message, attachments, url, user_agent).deliver

    render json: { success: true }
  end
end
