class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :description, :filename, :date_taken, :aws_filename, :upload_user_id, :upload_user_email
end
