include Common

class Plan < ActiveRecord::Base
  belongs_to :job

  has_one :plan_document
  has_one :document, through: :plan_document

  has_many :plan_document_histories
  has_many :document_histories, through: :plan_document_histories, source: :document

  has_many :plan_records

  PAPERCLIP_OPTIONS = get_s3_paperclip_options()
  TABS = ["plans", "addendums"]

  # DON"T UPDATE previous_plan_id and next_plan_id MANUALLY!  Use other methods.
  attr_accessible :job_id, :name, :num_pages, :tab, :csi, :plan_updated_at,
    :description, :code, :tags, :previous_plan_id, :next_plan_id
  attr_accessor :plan_num
  validates :job_id, :name, :tab, presence: true
  validates :status, :length => { :maximum => 50 }
  validates :description, :length => { :maximum => 20000 }
  validates :code, :length => { :maximum => 12 }
  validate :check_for_duplicate_name_for_tab
  validate :check_for_valid_tab_name

  after_create :add_to_end_of_list
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

  def tab=(tab)
    self[:tab] = tab.nil? ? tab : tab.downcase
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

    plan_count = Plan.count(
      conditions: ["job_id = ? AND tab = ?", self.job_id, self.tab],
    )
    first_plan = Plan.where(
      job_id: self.job_id,
      tab: self.tab,
      previous_plan_id: nil
    ).first

    plans = []
    current_plan = first_plan

    (1..plan_count).each do |i|
      plans << current_plan

      if current_plan.next_plan
        current_plan = current_plan.next_plan
      end
    end

    # If only one plan in list, it's this plan. Set prev and next to nil.
    # Zero case should never happen, but being safe.
    if plan_count <= 1
      self.next_plan_id = nil
      self.previous_plan_id = nil
      return self.save
    end

    # Pull plan from list
    current_before = nil
    current_pos = plans.index{ |p| p.id == self.id }
    current_after = plans[current_pos + 1]

    # Don't want a negative index
    if current_pos > 0
      current_before = plans[current_pos - 1]
    end

    if current_before and current_after
      current_before.next_plan_id = current_after.id
      current_after.previous_plan_id = current_before.id
    elsif current_before
      current_before.next_plan_id = nil
    elsif current_after
      current_after.previous_plan_id = nil
    end

    current_plan = plans.delete_at(current_pos)

    # Add plan at correct plan_num
    # If new plan_num is greater than count, set to last position.
    if plan_num > plan_count
      plan_num = plan_count
    end

    new_before = nil

    # Don't want a negative index
    if plan_num > 1
      new_before = plans[plan_num - 2]
    end
    new_after = plans[plan_num - 1]

    # Inserts before index
    plans.insert(plan_num - 1, current_plan)

    if new_before and new_after
      new_before.next_plan_id = current_plan.id
      current_plan.previous_plan_id = new_before.id
      current_plan.next_plan_id = new_after.id
      new_after.previous_plan_id = current_plan.id
    elsif new_before
      new_before.next_plan_id = current_plan.id
      current_plan.previous_plan_id = new_before.id
      current_plan.next_plan_id = nil
    elsif new_after
      current_plan.previous_plan_id = nil
      current_plan.next_plan_id = new_after.id
      new_after.previous_plan_id = current_plan.id
    else
      current_plan.previous_plan_id = nil
      current_plan.next_plan_id = nil
    end

    success = true

    # Save all plans that have changed
    plans.each do |p|
      success = success && p.save if p.changed?
    end

    return success
  end

  private

    def check_for_valid_tab_name
      if !TABS.include?(self.tab)
        errors.add(:tab, "isn't a valid tab")
      end
    end

    def check_for_duplicate_name_for_tab
      plans = Plan.where(
        job_id: self.job_id,
        tab: self.tab,
        name: self.name
      )

      if self.id
        plans = plans.where('id != ?', self.id)
      end

      if plans.count != 0
        errors.add(:name, 'already exists')
      end
    end

    def add_to_end_of_list
      last_plan = Plan.where(
        job_id: self.job_id,
        tab: self.tab,
        next_plan_id: nil
      ).where('id != ?', self.id).first

      if last_plan
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
