require 'securerandom'
require "aws-sdk"

VALID_PHOTO_EXT = ['png', 'jpg', 'jpeg', 'tiff', 'gif'];

class Api::PhotosController < ApplicationController
	before_filter :user_not_there!

  def update
    @photo = Photo.find(params[:id])

    # If we don't find the photo, then we can't check for the job
    if !@photo
      return render_no_permission
    end

    is_my_job = @photo.job.user_id == user.id
    is_my_photo = @photo.upload_user_id == user.id

    # Admins, job owner and the user that uploaded the photos can update
    if user.can?(:update, Photo) or is_my_job or is_my_photo
      @photo.description = params["photo"]["description"]

      if !@photo.save
        render json: {}
        return
      end

      render json: @photo
    else
      render_no_permission
    end
  end

  def destroy
    @photo = Photo.find(params[:id])

    # If we don't find the photo, then we can't check for the job
    if !@photo
      return render_no_permission
    end

    is_my_job = @photo.job.user_id == user.id
    is_my_photo = @photo.upload_user_id == user.id

    # Admins, job owner and the user that uploaded the photos can delete
    if user.can?(:destroy, Photo) or is_my_job or is_my_photo

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
      original_filename = file.original_filename
      file_ext = original_filename.split('.').pop
      # Don't process image if not a valid file extension
      next if !VALID_PHOTO_EXT.include?(file_ext)

      aws_filename = "#{SecureRandom.uuid}.#{file_ext}"
      redis_key = "photos:#{aws_filename}"

      exif_data = get_exif_data(file.tempfile.path)

      obj = s3.buckets[ENV["AWS_BUCKET"]].objects["photos/#{aws_filename}"];
      obj.write(file.tempfile)
      obj.acl = :public_read

      # Expire after a day
      Redis.current.setex(redis_key, 24 * 60 * 60, original_filename)

      returnData[:files].push({
        id: aws_filename,
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

      photos.each do |i, photo|
        aws_filename = photo["id"]
        filename = Redis.current.get("photos:#{aws_filename}")

        photo = Photo.create(
          filename: filename,
          date_taken: photo["date_taken"],
          aws_filename: aws_filename,
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
      obj = s3.buckets[ENV["AWS_BUCKET"]].objects["photos/#{@photo.aws_filename}"];

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
