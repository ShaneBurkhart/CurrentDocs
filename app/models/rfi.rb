class RFI < ActiveRecord::Base
  attr_accessible :subject, :due_date, :job_id, :assigned_user_id

  belongs_to :job
  belongs_to :assigned_user, class_name: "User", foreign_key: "assigned_user_id"
  has_one :asi, class_name: "ASI", foreign_key: "rfi_id"

  validates :job_id, presence: true
end
