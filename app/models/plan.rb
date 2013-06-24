# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  page_name  :string(255)
#  filename   :string(255)
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Plan < ActiveRecord::Base
	belongs_to :job
  attr_accessible :filename, :job_id, :plan_name, :plan_num
  validates :job_id, :plan_num, :plan_name, presence: true
  validate :check_for_duplicate_plan_name_in_job
  validate :check_for_duplicate_plan_num


	private
		def check_for_duplicate_plan_num
			p = Plan.find_all_by_job_id(self.job_id)
	  	p.each do |plan|
	  		if(plan.id == self.id)
	  			return
	  		end
  			if(plan.plan_num == self.plan_num)
  				errors.add(:plan_num, 'already exists')
  				return
	  		end
	  	end
		end

	  def check_for_duplicate_plan_name_in_job
	  	p = Plan.find_all_by_job_id(self.job_id)
	  	p.each do |plan|
	  		if(plan.id == self.id)
	  			return
	  		end
  			if(plan.plan_name == self.plan_name)
  				errors.add(:plan_name, 'already exists')
  				return
	  		end
	  	end
	  end

end
