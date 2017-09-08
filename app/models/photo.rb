class Photo < ActiveRecord::Base
  attr_accessible :description, :filename, :date_taken, :aws_file_id, :job_id, :upload_user_id
  belongs_to :job
  belongs_to :upload_user, :class_name => "User", :foreign_key => "upload_user_id"
  validates :filename, :date_taken, :aws_file_id, :job_id, :upload_user_id, presence: true

  def upload_user_email
    return upload_user.email
  end

  def upload_user_id
    return upload_user.id
  end
end
