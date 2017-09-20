class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :description, :filename, :date_taken, :aws_filename, :original_url, :thumbnail_url, :upload_user_id, :upload_user_email, :created_at
end
