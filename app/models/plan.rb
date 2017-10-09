# == Schema Information
#
# Table name: plans
#
#  id                :integer          not null, primary key
#  plan_name         :string(255)
#  filename          :string(255)
#  job_id            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  plan_num          :integer
#  plan_file_name    :string(255)
#  plan_content_type :string(255)
#  plan_file_size    :integer
#  plan_updated_at   :datetime
#

include Common
class Plan < ActiveRecord::Base
  belongs_to :job
  has_many :plan_records

  PAPERCLIP_OPTIONS = get_s3_paperclip_options()
  TABS = ["Plans", "ASI", "Shops", "Consultants", "Calcs & Misc", "Addendums"]

  attr_accessible :job_id, :plan_name, :plan_num, :num_pages, :tab, :csi,
    :plan_updated_at, :description, :code, :tags
  validates :job_id, :plan_num, :plan_name, :tab, presence: true
  validate :check_for_duplicate_plan_name_for_tab
  validate :check_for_valid_tab_name
  before_destroy :delete_plan_num
  validates :status, :length => { :maximum => 50 }
  validates :description, :length => { :maximum => 20000 }
  validates :code, :length => { :maximum => 12 }

  if Rails.env.production?
    has_attached_file :plan, PAPERCLIP_OPTIONS
  else
    has_attached_file :plan
  end

  # Get the next plan num for the tab
  def self.next_plan_num(job_id, tab)
    plans = Plan.where(job_id: job_id, tab: tab)
    return plans.length + 1
  end

  def delete_plan_num
    plans = Plan.where(
      job_id: self.job_id,
      tab: self.tab
    ).where('id != ?', self.id)

    plans.each do |plan|
      if plan.plan_num > self.plan_num
        plan.update_attributes(plan_num: plan.plan_num - 1)
      end
    end
  end

  def set_plan_num(num)
    highest = highest_plan_num
    newNum = num < 1 ? 1 : (num > highest ? highest : num) #check if greater than highests
    puts "The new plan_num is #{self.plan_num}"
    if newNum == self.plan_num
      return #return if nothing changed
    end
    new_num_index = newNum - 1
    p = Plan.find_all_by_job_id_and_tab(self.job_id, self.tab)
    p = p.sort_by{ |plan| plan.plan_num }
    old_num_index = p.index(self) # Find plan in sorted plans,
    # this is done in case self.plan_num is not a valid index.

    # Remove and insert plan based on index to achieve shifting of plans.
    temp = p.at(old_num_index)
    p.delete_at(old_num_index)
    p = p.insert(new_num_index, temp)

    p.each_with_index do |plan, index|
      # puts "Plan.inspect #{index}: #{plan.inspect}"
      plan.plan_num = index + 1
      plan.save
    end
  end

  private

    def highest_plan_num
      return self.job.plans.where(tab: self.tab).count;
    end

    def check_for_valid_tab_name
      if !TABS.include?(self.tab)
        errors.add(:tab, "isn't a valid tab")
      end
    end

    def check_for_duplicate_plan_name_for_tab
      plans = Plan.where(
        job_id: self.job_id,
        tab: self.tab,
        plan_name: self.plan_name
      ).where('id != ?', self.id)

      if plans.length != 0
        errors.add(:plan_name, 'already exists')
      end
    end
end
