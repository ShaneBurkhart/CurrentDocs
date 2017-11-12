class ASI < ActiveRecord::Base
  attr_accessible :asi_num, :status, :subject, :notes, :plan_sheets_affected, :in_addendum, :job_id, :rfi_id, :user_id, :assigned_user_id

  STATUSES = ["Open", "Closed"]

  belongs_to :job
  belongs_to :user
  belongs_to :rfi, class_name: "RFI", foreign_key: "rfi_id"
  belongs_to :assigned_user, class_name: "User", foreign_key: "assigned_user_id"
  has_many :attachments, class_name: "ASIAttachment", foreign_key: "asi_id"

  validates :subject, :job_id, :user_id, presence: true
  validate :check_status

  before_create :generate_asi_num

  private

    def check_status
      if !STATUSES.include?(self.status)
        return errors.add(:status, "isn't a valid status")
      end
    end

    def generate_asi_num
      # If asi_num is present, don't do anything.
      # We set it manually
      return if self.asi_num

      now = DateTime.now
      formatted_date = now.strftime("%y%m%d")

      asis = ASI.where(job_id: self.job_id).where(
        "asi_num LIKE ?", "#{formatted_date}%"
      )

      if asis.length != 0
        self.asi_num = "#{formatted_date}-#{asis.length}"
      else
        self.asi_num = formatted_date
      end
    end
end
