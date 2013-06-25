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
  #before_validation :fix_plan_num


	private
		def fix_plan_num
			#check if greater than highest
			highest = highest_plan_num
			self.plan_num = plan_num > highest ? highest : self.plan_num
			
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

		def highest_plan_num
			greatest = 1
      begin
        Plan.find_all_by_job_id(self.job_id).each do |plan|
          if plan.plan_num >= greatest
            greatest = plan.plan_num
          end
        end
        return greatest
      rescue
        return greatest
      end
		end

		def plan_num_exists?
			p = Plan.find_all_by_job_id(self.job_id)
	  	p.each do |plan|
	  		if(plan.id == self.id)
	  			return
	  		end
  			if(plan.plan_num == self.plan_num)
  				return true
	  		end
	  	end
	  	return false
		end

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
