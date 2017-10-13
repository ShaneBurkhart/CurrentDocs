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

  # DON"T UPDATE previous_plan_id and next_plan_id MANUALLY!  Use other methods.
  attr_accessible :job_id, :plan_name, :num_pages, :tab, :csi, :plan_updated_at,
    :description, :code, :tags, :previous_plan_id, :next_plan_id
  validates :job_id, :plan_name, :tab, presence: true
  validate :check_for_duplicate_plan_name_for_tab
  validate :check_for_valid_tab_name
  validates :status, :length => { :maximum => 50 }
  validates :description, :length => { :maximum => 20000 }
  validates :code, :length => { :maximum => 12 }

  after_create :move_to_end_of_list
  before_destroy :delete_plan_in_list

  if Rails.env.production?
    has_attached_file :plan, PAPERCLIP_OPTIONS
  else
    has_attached_file :plan
  end

  def next_plan
    return Plan.where(id: self.next_plan_id).first
  end

  def previous_plan
    return Plan.where(id: self.previous_plan_id).first
  end

  def csi=(csi_code)
    if !csi_code or csi_code == 0 or csi_code == ""
      self[:csi] = nil
    else
      self[:csi] = csi_code
    end
  end

  def move_to_plan_num(plan_num)
    # If this record doesn't have an id, then we can't move it
    return if !self.id

    # Make sure the plan_num is positive non-zero
    plan_num = 1 if plan_num <= 0

    plans_for_tab = Plan.where(job_id: self.job_id, tab: self.tab)
    plans_by_id = plans_for_tab.map.with_index { |p, i| [p.id, p] }.to_h
    first_plan = plans_for_tab.find { |plan| plan.previous_plan_id == nil }

    current_plan = first_plan

    # Go through linked list until index matches plan_num
    # If we make it all the way through, then we'll insert after last plan
    plans_for_tab.each_with_index do |plan, i|
      # Add one to plan_num if we see self.id. Our new plan_num is after self's
      # current position. Since we move self before, we need to go one spot more.
      if self.id == current_plan.id
        plan_num += 1
      end

      puts i + 1
      puts current_plan.inspect

      # We found the plan for the plan_num.  We'll insert before
      break if plan_num == i + 1

      # Set next plan as current plan to go through linked list
      if current_plan.next_plan_id
        current_plan = plans_by_id[current_plan.next_plan_id]
      else
        current_plan = nil
      end
    end

    if !current_plan
      return self.move_to_end_of_list
    end

    # The plan is already in the correct spot
    if self.id == current_plan.id
      return true
    else
      return self.move_to_before_plan_id(current_plan.id)
    end
  end

  def move_to_end_of_list
    # If this record doesn't have an id, then we can't add it to the list
    return if !self.id

    last_plan = Plan.where(
      job_id: self.job_id,
      tab: self.tab,
      next_plan_id: nil
    ).where('id != ?', self.id).first

    # Remove plan from list before moving
    delete_plan_in_list

    if last_plan
      # Since we've updated the plans list by removing self, we need to reload
      last_plan.reload

      last_plan.next_plan_id = self.id
      self.previous_plan_id = last_plan.id

      last_plan.save
    else
      # No plans in list so this is the first.  Nil previous_plan_id
      self.previous_plan_id = nil
    end

    # Moving to Last plan in the list so setting next_plan_id to nil
    self.next_plan_id = nil
    return self.save
  end

  # Reorder plans so that this plan is after the given plan_id
  def move_to_before_plan_id(plan_id)
    # If this record doesn't have an id, then we can't add it to the list
    return if !self.id
    # plan_id can't be the current id
    return if self.id == plan_id

    if !plan_id
      # This really means we are inserting at the end of the list
      return self.move_to_end_of_list
    end

    # Select where job_id and tab match as a validation of plan_id
    plan_after = Plan.where(
      id: plan_id,
      job_id: self.job_id,
      tab: self.tab
    ).first
    # If we didn't find a plan_after, it's a validation issue.
    # This method takes a plan_id specifically so not found isn't okay.
    return if !plan_after

    # Remove plan from list before moving
    delete_plan_in_list
    # Since we've updated the plans list by removing self, we need to reload
    plan_after.reload

    previous_plan = plan_after.previous_plan

    if previous_plan
      self.previous_plan_id = previous_plan.id
      previous_plan.next_plan_id = self.id

      previous_plan.save
    else
      # There is no next plan which means plan_after is first in list.
      self.previous_plan_id = nil
    end

    plan_after.previous_plan_id = self.id
    plan_after.save

    self.next_plan_id = plan_after.id
    return self.save
  end

  private

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

    # When removing a plan, we need to update next_plan_id and previous_plan_id
    def delete_plan_in_list
      next_plan = self.next_plan
      previous_plan = self.previous_plan

      if previous_plan and next_plan
        # Middle of list
        next_plan.previous_plan_id = self.previous_plan_id
        previous_plan.next_plan_id = self.next_plan_id

        next_plan.save
        previous_plan.save
      elsif next_plan
        # First in list
        next_plan.previous_plan_id = nil

        next_plan.save
      elsif previous_plan
        # Last in list
        previous_plan.next_plan_id = nil

        previous_plan.save
      end
    end
end
