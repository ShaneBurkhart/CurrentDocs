class Plan < ActiveRecord::Base
	belongs_to :job
  attr_accessible :filename, :job_id, :page_name
  validates :filename, :job_id, :page_name, presence: true
  validate :check_for_duplicate_page_name_in_job


	private
	  def check_for_duplicate_page_name_in_job
	  	p = Plan.find_all_by_job_id(self.job_id)
	  	p.each do |plan|
	  		p.each do |tmp|
	  			if(plan.page_name == tmp.page_name)
	  				errors.add(:page_name, 'already exists')
	  				return
	  			end
	  		end
	  	end
	  end

end
