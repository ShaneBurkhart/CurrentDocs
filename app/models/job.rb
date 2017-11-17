class Job < ActiveRecord::Base
  attr_accessible :name, :user_id, :archived

  belongs_to :user
  has_many :all_plans, class_name: "Plan", foreign_key: "job_id"
  has_many :plans, class_name: "Plan", foreign_key: "job_id", conditions: { tab: "plans" }
  has_many :addendums, class_name: "Plan", foreign_key: "job_id", conditions: { tab: "addendums" }

  validates :user_id, presence: true
  validates :name, presence: true
  validate :check_for_duplicate_name_for_user

  before_destroy :destroy_plans

  def get_plans_for_tabs_with_plan_num(tabs)
    plans = get_plans_for_tabs(tabs)

    current_plan_id = nil
    plans.each_with_index do |p, i|
      plans.each_with_index do |plan, j|

        if plan.previous_plan_id == current_plan_id
          plan.plan_num = i + 1
          current_plan_id = plan.id
          break
        end
      end
    end

    return plans.sort { |a, b| a.plan_num <=> b.plan_num  }
  end

  private

    def destroy_plans
      self.plans.destroy_all
    end

    def check_for_duplicate_name_for_user
      j = Job.where(user_id: self.user_id, name: self.name)

      if self.id
        j = j.where('id != ?', self.id)
      end

      if j.count != 0
        errors.add(:name, 'already exists')
      end
    end
end
