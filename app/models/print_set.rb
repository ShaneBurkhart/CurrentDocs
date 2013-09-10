# == Schema Information
#
# Table name: print_sets
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
