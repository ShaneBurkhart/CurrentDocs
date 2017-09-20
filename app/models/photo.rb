class Photo < ActiveRecord::Base
  attr_accessible :description, :filename, :date_taken, :aws_filename, :job_id, :upload_user_id
  belongs_to :job
  belongs_to :upload_user, :class_name => "User", :foreign_key => "upload_user_id"
  validates :filename, :date_taken, :aws_filename, :job_id, :upload_user_id, presence: true

  def upload_user_email
    return upload_user.email
  end

  def upload_user_id
    return upload_user.id
  end

  def original_url
    return "https://s3.amazonaws.com/#{ENV['AWS_BUCKET']}/photos/#{self.aws_filename}"
  end

  def thumbnail_url
    return "https://s3.amazonaws.com/#{ENV['AWS_BUCKET']}/thumbnails/#{self.aws_filename}"
  end
end
