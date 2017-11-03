class RFI < ActiveRecord::Base
  attr_accessible :rfi_num, :subject, :notes, :due_date, :job_id, :user_id, :assigned_user_id

  belongs_to :job
  belongs_to :user
  belongs_to :assigned_user, class_name: "User", foreign_key: "assigned_user_id"
  has_one :asi, class_name: "ASI", foreign_key: "rfi_id"
  has_many :attachments, class_name: "RFIAttachment", foreign_key: "rfi_id"

  validates :job_id, presence: true

  before_create :generate_rfi_num

  private

    def generate_rfi_num
      now = DateTime.now
      formatted_date = now.strftime("%y%m%d")

      rfis = RFI.where(job_id: self.job_id).where(
        "rfi_num LIKE ?", "#{formatted_date}%"
      )

      if rfis.length != 0
        self.rfi_num = "#{formatted_date}-#{rfis.length}"
      else
        self.rfi_num = formatted_date
      end
    end
end
