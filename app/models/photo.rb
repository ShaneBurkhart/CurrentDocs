class Photo < ActiveRecord::Base
  attr_accessible :description, :filename, :date_taken, :aws_file_id, :job_id, :upload_user_id
  has_one :job
  validates :filename, :date_taken, :aws_file_id, :job_id, :upload_user_id, presence: true
end
