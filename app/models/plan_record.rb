include Common
class PlanRecord < ActiveRecord::Base
  belongs_to :plan

  PAPERCLIP_OPTIONS = get_s3_paperclip_options()

  if Rails.env.production?
    has_attached_file :plan_record, PAPERCLIP_OPTIONS
  else
    has_attached_file :plan_record
  end

  # validates_attachment_content_type :plan, :content_type => %w(application/pdf)
  attr_accessor :plan_record_file_name
  attr_accessible :job_id, :plan_id, :plan_name, :plan_num, :tab, :csi, :filename
  validates :plan_id, :plan_name, :tab, presence: true
  before_destroy :delete_file
  # validate :ensure_plans_have_unique_plan_nums, :on => :save
  # validates_uniqueness_of :plan_num, scope: [:tab, :job_id]
  def delete_file
  	path = Rails.root.join("public", "_files", self.id.to_s)
  	return unless File.exists?(path)
  	File.delete path
  end
end
