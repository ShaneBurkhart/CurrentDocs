include Common

class Plan < ActiveRecord::Base
  TABS = ["plans", "addendums"]

  belongs_to :job

  has_one :plan_document
  has_one :document, through: :plan_document

  has_many :plan_document_histories
  has_many :document_histories, through: :plan_document_histories, source: :document

  attr_accessible :job_id, :name, :order_num, :num_pages, :tab, :csi,
    :plan_updated_at, :description, :code, :tags

  validates :job_id, :name, :tab, presence: true
  validates :order_num, presence: true, on: :update
  validates :status, :length => { :maximum => 50 }
  validates :description, :length => { :maximum => 20000 }
  validates :code, :length => { :maximum => 12 }
  validate :check_for_duplicate_name_for_tab
  validate :check_for_valid_tab_name

  before_create :add_to_end_of_list
  before_destroy :delete_plan_in_list

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

  def move_to_position(pos)
    # If this record doesn't have an id, then we can't move it
    return false if !self.id

    # Make sure the order_num is positive
    pos = 1 if pos <= 0

    plans = Plan.where(job_id: self.job_id, tab: self.tab)
      .order('order_num ASC').to_a

    pos = plans.length if pos > plans.length

    this_plan = plans.delete_at(plans.index{ |p| p.id == self.id })

    plans.insert(pos - 1, this_plan)

    success = true

    plans.each_with_index do |plan, i|
      plan.order_num = i
      success = success && plan.save if plan.order_num_changed?
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
      # We don't want to call this if the plan already exists
      return if self.id

      plan_count = Plan.where(
        job_id: self.job_id,
        tab: self.tab,
      ).count

      self.order_num = plan_count
    end

    # When removing a plan, we need to update next_plan_id and previous_plan_id
    def delete_plan_in_list
      # If this record doesn't have an id, then we can't move it
      return if !self.id

      plans = Plan.where(job_id: self.job_id, tab: self.tab)
        .order('order_num ASC').to_a

      this_plan = plans.delete_at(plans.index{ |p| p.id == self.id })

      success = true

      plans.each_with_index do |plan, i|
        plan.order_num = i
        success = success && plan.save if plan.order_num_changed?
      end

      return success
    end
end
