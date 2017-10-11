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
  has_one :next_plan, :class_name => "Plan", :foreign_key => "next_plan_id"
  has_one :previous_plan, :class_name => "Plan", :foreign_key => "previous_plan_id"

  PAPERCLIP_OPTIONS = get_s3_paperclip_options()
  TABS = ["Plans", "ASI", "Shops", "Consultants", "Calcs & Misc", "Addendums"]

  attr_reader :previous_plan_id, :next_plan_id
  attr_accessible :job_id, :plan_name, :num_pages, :tab, :csi,
    :plan_updated_at, :description, :code, :tags
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

  def csi=(csi_code)
    if !csi_code or csi_code == 0 or csi_code == ""
      self[:csi] = nil
    else
      self[:csi] = csi_code
    end
  end

  # Insert plan at the beginning of the list
  def move_to_front_of_list
    # If this record doesn't have an id, then we can't add it to the list
    return if !self.id

    # Find first plan in list
    first_plan = Plan.where(
      job_id: self.job_id,
      tab: self.tab,
      previous_plan_id: nil
    ).where('id != ?', self.id).first

    if first_plan
      self[:next_plan_id] = first_plan.id
      first_plan[:previous_plan_id] = self.id
    else
      # The current plan is the only plan in list
      self[:next_plan_id] = nil
    end

    # Moving to first plan in list so previous_plan_id is nil
    self[:previous_plan_id] = nil
    self.save
  end

  def move_to_end_of_list
    # If this record doesn't have an id, then we can't add it to the list
    return if !self.id

    last_plan = Plan.where(
      job_id: self.job_id,
      tab: self.tab,
      next_plan_id: nil
    ).where('id != ?', self.id).first

    if last_plan
      last_plan[:next_plan_id] = self.id
      self[:previous_plan_id] = last_plan.id

      last_plan.save
    else
      # No plans in list so this is the first.  Nil previous_plan_id
      self[:previous_plan_id] = nil
    end

    # Moving to Last plan in the list so setting next_plan_id to nil
    self[:next_plan_id] = nil
    self.save
  end

  # Reorder plans so that this plan is after the given plan_id
  def move_to_after_plan_id(plan_id)
    # If this record doesn't have an id, then we can't add it to the list
    return if !self.id
    # plan_id can't be the current id
    return if self.id == plan_id

    if !plan_id
      # This really means we are inserting at the front of the list
      return self.insert_at_beginning
    end

    # Select where job_id and tab match as a validation of plan_id
    plan_before = Plan.where(
      id: plan_id,
      job_id: self.job_id,
      tab: self.tab
    ).first
    # If we didn't find a plan_before, it's a validation issue.
    # This method takes a plan_id specifically so not found isn't okay.
    return if !plan_before

    next_plan = plan_before.next_plan

    if next_plan
      self[:next_plan_id] = next_plan.id
      next_plan[:previous_plan_id] = self.id

      next_plan.save
    else
      # There is no next plan which means plan_before is last in list.
      self[:next_plan_id] = nil
    end

    plan_before[:next_plan_id] = self.id
    plan_before.save

    self[:previous_plan_id] = plan_before.id
    self.save
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
      if self.previous_plan and self.next_plan
        # Middle of list
        self.next_plan[:previous_plan_id] = self.previous_plan_id
        self.previous_plan[:next_plan_id] = self.next_plan_id

        self.next_plan.save
        self.previous_plan.save
      elsif self.next_plan
        # First in list
        self.next_plan[:previous_plan_id] = nil

        self.next_plan.save
      elsif self.previous_plan
        # Last in list
        self.previous_plan[:next_plan_id] = nil

        self.previous_plan.save
      end
    end
end
