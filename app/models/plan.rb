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
  attr_accessible :filename, :job_id, :page_name
  validates :filename, :job_id, :page_name, presence: true
  validate :check_for_duplicate_page_name_in_job


	private
	  def check_for_duplicate_page_name_in_job
	  	p = Plan.find_all_by_job_id(self.job_id)
	  	p.each do |plan|
  			if(plan.page_name == self.page_name)
  				errors.add(:page_name, 'already exists')
  				return
	  		end
	  	end
	  end

end
