# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  tab        :string(255)      not null
#  job_id     :integer          not null
#  order_num  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_plans_on_job_id     (job_id)
#  index_plans_on_order_num  (order_num)
#  index_plans_on_tab        (tab)
#

class Plan < ActiveRecord::Base
  # Keep these in order please. They determine some rendering orders:
  # - JobPermissionsController#edit
  TABS = ["plans", "addendums"]

  attr_accessible :name

  belongs_to :job

  has_one :plan_document, class_name: "PlanDocument", foreign_key: "plan_id", conditions: { is_current: true }
  has_many :plan_document_histories, class_name: "PlanDocument", foreign_key: "plan_id", conditions: { is_current: false }, order: "created_at DESC"

  has_one :document, class_name: "Document", through: :plan_document, as: :document
  has_many :document_histories, class_name: "Document", through: :plan_document_histories, source: :document, order: "created_at DESC"

  validates :job_id, :name, :tab, presence: true
  # We only want to add to list if it passes other validations.
  # Check before_create :add_to_end_of_list for where order_num is set.
  validates :order_num, presence: true, on: :update

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

  def update_document(document)
    return false if document.nil?
    return true if self.document == document

    if self.document
      self.plan_document.is_current = false

      if !self.plan_document.save
        errors.add(:document, "couldn't be set to current document")
        return false
      end
    end

    current_doc = PlanDocument.new
    current_doc.is_current = true
    current_doc.plan_id = self.id

    if !current_doc.save
      errors.add(:document, "couldn't be set to current document")
      return false
    end

    document.document_association = current_doc

    if !document.save
      errors.add(:document, "couldn't be set to current document")
      return false
    end

    # Now that we have updated everything, we need to reload
    self.reload

    return true
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
