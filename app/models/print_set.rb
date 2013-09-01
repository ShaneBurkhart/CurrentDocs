class PrintSet < ActiveRecord::Base
  attr_accessible :job_id
  belongs_to :job
  has_many :plans

  def clear_plans
    self.plans.each do |plan|
      plan.print_set_id = nil
      plan.save
    end
  end
end
