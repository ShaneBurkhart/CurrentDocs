# == Schema Information
#
# Table name: plans
#
#  id                :integer          not null, primary key
#  plan_name         :string(255)
#  filename          :string(255)
#  job_id            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  plan_num          :integer
#  plan_file_name    :string(255)
#  plan_content_type :string(255)
#  plan_file_size    :integer
#  plan_updated_at   :datetime
#

class Plan < ActiveRecord::Base
  belongs_to :job

  PAPERCLIP_OPTIONS = {
    :storage => :s3,
    :s3_credentials => {
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
    :bucket => ENV["AWS_BUCKET"]
    },
    :path => ":attachment/:id.:extension",
    :bucket => ENV["AWS_BUCKET"]
  }

  if Rails.env.production?
    has_attached_file :plan, PAPERCLIP_OPTIONS
  else
    has_attached_file :plan
  end

  validates_attachment_content_type :plan, :content_type => %w(application/pdf)

  attr_accessible :job_id, :plan_name, :plan_num, :num_pages
  validates :job_id, :plan_num, :plan_name, presence: true
  validate :check_for_duplicate_plan_name_in_job
  before_destroy :delete_file, :delete_plan_num

  def self.next_plan_num(job_id)
    greatest = 0
    begin
      Job.find(job_id).plans.each do |plan|
        if plan.plan_num >= greatest
          greatest = plan.plan_num
        end
      end
      return greatest + 1
    rescue
      return greatest
    end
  end

  def delete_file
  	path = Rails.root.join("public", "_files", self.id.to_s)
  	return unless File.exists?(path)
  	File.delete path
  end

  def delete_plan_num
  	p = Plan.find_all_by_job_id(self.job_id)
  	p.each do |plan|
  		next unless(plan.id != self.id)
			if plan.plan_num > self.plan_num
				plan.update_attributes(:plan_num => plan.plan_num - 1)
  		end
  	end
  end

	def set_plan_num(num)
		oldNum = self.plan_num
		highest = highest_plan_num
		self.plan_num = num < 1 ? 1 : (num > highest ? highest : num) #check if greater than highests
		if self.plan_num == oldNum
			return #return if nothing changed
		end
		if self.plan_num > oldNum
			op = ">"; at = "-"; op2 = "<="
		else
			op = "<";	at = "+"; op2 = ">="
		end
		p = Plan.find_all_by_job_id(self.job_id)
  	p.each do |plan|
  		next unless(plan.id != self.id)
			if(plan.plan_num.send(op, oldNum) && plan.plan_num.send(op2, self.plan_num))
				plan.update_attributes(:plan_num => plan.plan_num.send(at, 1))
  		end
  	end
	end

		private

		def highest_plan_num
      return self.job.plans.count
		end

		def plan_num_exists?
			p = Plan.find_all_by_job_id(self.job_id)
	  	p.each do |plan|
	  		if(plan.id == self.id)
	  			next
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
	  			next
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
	  			next
	  		end
  			if(plan.plan_name == self.plan_name)
  				errors.add(:plan_name, 'already exists')
  				return
	  		end
	  	end
	  end

end
