class RFI < ActiveRecord::Base
  attr_accessible :status, :subject, :plan_sheets_affected, :in_addendum, :due_date, :job_id, :assigned_user_id, :asi_id

  STATUSES = ["Open", "Closed"]

  belongs_to :job
  belongs_to :assigned_user, class_name: "User", foreign_key: "assigned_user_id"
  has_one :asi

  validates :job_id, presence: true
  validate :check_status

  private

    def check_status
      if !STATUSES.include?(self.status)
        return errors.add(:status, "isn't a valid status")
      end

      if !self.asi_id and status == "Closed"
        errors.add(:status, "isn't a valid status without an ASI")
      end
    end
end
