# == Schema Information
#
# Table name: jobs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Job < ActiveRecord::Base
  belongs_to :user
  has_many :plan_records
  has_many :plans, order: "plan_num ASC"
  has_many :shares
  has_many :shared_users, through: :shares, source: :user
  has_many :submittals, conditions: "is_accepted = false"
  has_many :photos
  attr_accessible :name, :user_id, :archived, :subscribed
  attr_accessor :subscribed
  validates :user_id, presence: true
  validates :name, presence: true#, uniqueness: true
  validate :check_for_dubplicate_name_for_single_user

  before_destroy :destroy_plans
  before_destroy :destroy_shares

  # Blank and nil status goes last
  SHOPS_REPORTS_STATUS_ORDER = ["Pending", "Submitted", "Approved", "Approved as Corrected", "Revise & Resubmit", "Record Copy", ""]

  # rendering json is done in two steps. as_json, then to_json.
  # This overrides as_json for a Job to include specified
  # non-persisting attributes.
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:subscribed])
    super options
  end

  def get_plans_for_tabs(tabs)
    self.plans.select{ |plan| tabs.include? plan.tab }
  end

  def send_message_to_group(message)
    shared_users.each do |shared_user|
      shared_user.send_message user.email, "This message is to the #{name} group:\n\n#{message}"
    end
  end

  def ordered_shop_drawings
    last_index = SHOPS_REPORTS_STATUS_ORDER.count

    return plans.where(tab: "Shops").sort do |a, b|
      # Default to last index if didn't find index
      aNum = SHOPS_REPORTS_STATUS_ORDER.find_index(a.status) || last_index
      bNum = SHOPS_REPORTS_STATUS_ORDER.find_index(b.status) || last_index
      next aNum <=> bNum
    end
  end

  private
  def destroy_shares
    self.shares.each do |share|
      share.destroy
    end
  end

  def destroy_plans
    self.plans.each do |plan|
      plan.destroy
    end
  end

  def check_for_dubplicate_name_for_single_user
    j = Job.find_all_by_user_id_and_name(self.user_id, self.name)
    if j.count > 1 || (j.count == 1 && j.first.id != self.id) then
      errors.add(:name, 'already exists')
    end
  end
end
