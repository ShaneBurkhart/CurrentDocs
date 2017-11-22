class DocumentController < ApplicationController
  before_filter :authenticate_user!

  def upload
    # TODO Add expiration for uploaded files that aren't associated later.
    # Upload attachments to s3 and add to redis with expiration. On create
    # plan association (PlanDocument, etc), we fetch the attachments from
    # redis from hidden inputs. When record expires, we remove s3 file.
    # Remove record manually when used.
    s3 = AWS::S3.new
    files = params["files"]
    returnData = { files: [] }

    authorize! :upload, Document

    files.each do |key, file|
      uuid = SecureRandom.uuid
      redis_key = "documents:#{uuid}"
      original_filename = file.original_filename

      obj = s3.buckets[ENV["AWS_BUCKET"]].objects["documents/#{uuid}"];
      obj.write(file.tempfile)

      # Expire after a day
      Redis.current.setex(redis_key, 24 * 60 * 60, original_filename)

      returnData[:files].push({ id: uuid, original_filename: original_filename })
    end

    render json: returnData
  end

  def download
    @document = Document.find(params[:id])

    authorize! :download, @document

    s3 = AWS::S3.new
    obj = s3.buckets[ENV["AWS_BUCKET"]].objects[@document.s3_path];

    send_data obj.read, filename: @document.original_filename, stream: 'true', buffer_size: '4096'
  end
end
