class DocumentController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => [:upload]

  def show
    @document = Document.find(params[:id])

    authorize! :read, @document

    render :show, layout: false
  end

  def upload
    # TODO Add expiration for uploaded files that aren't associated later.
    # We upload to S3 and create a Document for the upload. We then send the id
    # back to the form which gets added to the plan when form is submitted.
    s3 = AWS::S3.new
    files = params["files"]
    # Make sure files is an multi file hash even when only uploading one file.
    # This happens when you turn off the multi file upload on dropzone.
    files = { "0": files } unless files.is_a?(Hash)
    returnData = { files: [] }

    authorize! :upload, Document

    files.each do |key, file|
      uuid = SecureRandom.uuid
      document = Document.create(
        s3_path: "documents/#{uuid}",
        original_filename: file.original_filename
      )
      document.user_id = current_user.id

      next if !document.save

      obj = s3.buckets[ENV["AWS_BUCKET"]].objects[document.s3_path];
      obj.write(file.tempfile)
      obj.acl = :public_read

      returnData[:files].push({
        id: document.id,
        original_filename: document.original_filename
      })
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
