class Job < ActiveRecord::Base
  attr_accessible :name, :is_archived

  belongs_to :team
  belongs_to :user
  has_many :all_plans, class_name: "Plan", foreign_key: "job_id"
  has_many :plans, class_name: "Plan", foreign_key: "job_id", conditions: { tab: "plans" }, order: "order_num ASC"
  has_many :addendums, class_name: "Plan", foreign_key: "job_id", conditions: { tab: "addendums" }, order: "order_num ASC"

  validates :name, :team_id, :user_id, presence: true
  validate :check_for_duplicate_name_for_user

  before_destroy :destroy_plans

  # We're adding these because #plans.build adds the unsaved record
  # to plan when we are just using it to check CanCan permissions.
  def new_plan(tab)
    p = Plan.new
    p.job_id = self.id
    p.tab = tab
    return p
  end

  private

    def check_for_duplicate_name_for_user
      j = Job.where(user_id: self.user_id, name: self.name)

      if self.id
        j = j.where('id != ?', self.id)
      end

      if j.count != 0
        errors.add(:name, 'already exists')
      end
    end

    def destroy_plans
      self.plans.destroy_all
    end
end
