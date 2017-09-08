require 'securerandom'
require "aws-sdk"

class Api::PhotosController < ApplicationController
	before_filter :user_not_there!

  def destroy
    # Only admins can destroy photos
    if user.can? :destroy, Photo
      @photo = Photo.find(params[:id])

      @photo.destroy
      render json: @photo
    else
      render_no_permission
    end
  end

  def upload_photos
    # Upload photos to s3 and add to redis with expiration.
    # When record expires, we remove s3 file. Remove record manually when used.
    files = params["files"]
    returnData = { files: [] }

    s3 = AWS::S3.new
    files.each do |key, file|
      uuid = SecureRandom.uuid
      redis_key = "photos:#{uuid}"
      original_filename = file.original_filename

      exif_data = get_exif_data(file.tempfile.path)

      obj = s3.buckets[ENV["AWS_BUCKET"]].objects["photos/#{uuid}"];
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

  def submit_photos
    job = Job.find(params["job_id"])

    # I think the permissions passed to is_shared_job are photos permissions.
    # Should work on refactoring to constants, but client side needs constants too.
    if job && (user.is_my_job(job) || user.is_shared_job(job, 0b10000))
      photos = params["photos"] || []
      puts photos

      photos.each do |i, photo|
        aws_file_id = photo["id"]
        filename = Redis.current.get("photos:#{aws_file_id}")

        photo = Photo.create(
          filename: filename,
          date_taken: photo["date_taken"],
          aws_file_id: aws_file_id,
          job_id: job.id,
          upload_user_id: user.id,
        )
      end

      # Send notification to owner
      #UserMailer.submittal_notification(@submittal).deliver

      render json: { photos: job.photos }
    else
      render_no_permission
    end
  end

  def download_photo
    @photo = Photo.find(params[:id])

    if @photo
      s3 = AWS::S3.new
      obj = s3.buckets[ENV["AWS_BUCKET"]].objects["photos/#{@photo.aws_file_id}"];

      send_data obj.read, filename: @photo.filename, stream: 'true', buffer_size: '4096'
    else
      render_no_permission
    end
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
