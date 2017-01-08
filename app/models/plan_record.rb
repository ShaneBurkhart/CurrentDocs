include Common
class PlanRecord < ActiveRecord::Base
  belongs_to :plan
  belongs_to :job

  PAPERCLIP_OPTIONS = get_s3_paperclip_options()

  if Rails.env.production?
    has_attached_file :plan_record, PAPERCLIP_OPTIONS
  else
    has_attached_file :plan_record
  end

  # validates_attachment_content_type :plan, :content_type => %w(application/pdf)

  validates :plan_record, attachment_presence: true
  attr_accessible :plan_id, :filename, :plan_updated_at, :plan_record_file_name, :plan_record, :archived
  validates :plan_id, presence: true
  before_destroy :delete_file
  # validate :ensure_plans_have_unique_plan_nums, :on => :save
  # validates_uniqueness_of :plan_num, scope: [:tab, :job_id]
  def delete_file
  	path = Rails.root.join("public", "_files", self.id.to_s)
  	return unless File.exists?(path)
  	File.delete path
  end
end
