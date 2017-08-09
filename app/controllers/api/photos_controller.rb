require 'securerandom'
require "aws-sdk"

class Api::PhotosController < ApplicationController
	before_filter :user_not_there!

  def upload_photos
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

      exif_data = get_exif_data(file.tempfile.path)

      obj = s3.buckets[ENV["AWS_BUCKET"]].objects["attachments/#{uuid}"];
      obj.write(file.tempfile)

      # Expire after a day
      Redis.current.setex(redis_key, 24 * 60 * 60, original_filename)

      returnData[:files].push({
        id: uuid,
        original_filename: original_filename,
        date_taken: exif_data && exif_data[:date_time] ? exif_data[:date_time] : nil,
      })
    end

    render json: returnData
  end

  private

    def get_exif_data(file_path)
      begin
        return Exif::Data.new(file_path)
      rescue RuntimeError => e
        puts e
        return nil
      end
    end
end
