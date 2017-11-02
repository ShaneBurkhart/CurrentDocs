class ASI < ActiveRecord::Base
  attr_accessible :status, :subject, :plan_sheets_affected, :in_addendum, :job_id, :rfi_id, :assigned_user_id

  STATUSES = ["Open", "Closed"]

  belongs_to :job
  belongs_to :rfi, class_name: "RFI", foreign_key: "rfi_id"
  belongs_to :assigned_user, class_name: "User", foreign_key: "assigned_user_id"

  validates :job_id, presence: true
  validate :check_status

  private

    def check_status
      if !STATUSES.include?(self.status)
        return errors.add(:status, "isn't a valid status")
      end
    end
end
