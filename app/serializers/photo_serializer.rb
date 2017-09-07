class PhotoSerializer < ActiveModel::Serializer
  attributes :description, :filename, :date_taken, :aws_file_id, :upload_user_email
end
