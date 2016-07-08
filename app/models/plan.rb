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

include Common
class Plan < ActiveRecord::Base
  belongs_to :job
  has_many :plan_records

  PAPERCLIP_OPTIONS = get_s3_paperclip_options()

  if Rails.env.production?
    has_attached_file :plan, PAPERCLIP_OPTIONS
  else
    has_attached_file :plan
  end

  # validates_attachment_content_type :plan, :content_type => %w(application/pdf)

  attr_accessible :job_id, :plan_name, :plan_num, :num_pages, :tab, :csi, :plan_updated_at
  validates :job_id, :plan_num, :plan_name, :tab, presence: true
  validate :check_for_duplicate_plan_name_in_job
  validate :check_for_valid_tab_name
  before_destroy :delete_file, :delete_plan_num
  validates :status, :length => { :maximum => 50 }
  # validate :ensure_plans_have_unique_plan_nums, :on => :save
  # validates_uniqueness_of :plan_num, scope: [:tab, :job_id]

  def find_all_by_job_id_and_tab(job_id, desired_tab)
    plans = Plan.find_all_by_job_id(job_id)
    relavent_plans = plans.select do |plan| # Select all plans in desired tab
      plan.tab == desired_tab
    end
    return relavent_plans
  end

  def self.next_plan_num(job_id, tab)
    plans = Plan.find_all_by_job_id_and_tab(job_id, tab)
    return plans.count + 1
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
		newNum = num < 1 ? 1 : (num > highest ? highest : num) #check if greater than highests
    puts "The new plan_num is #{self.plan_num}"
		if newNum == oldNum
			return #return if nothing changed
		end
    old_num_index = oldNum - 1
    new_num_index = newNum - 1
    p = Plan.find_all_by_job_id_and_tab(self.job_id, self.tab)
    p = p.sort_by{ |plan| plan.plan_num }

    puts "Old"
    p.each do |plan|
      puts plan.inspect
    end

    temp = p.at(old_num_index)
    p.delete_at(old_num_index)
    p = p.insert(new_num_index, temp)

    puts "New"
    p.each do |plan|
      puts plan.inspect
    end

    p.each_with_index do |plan, index|
      plan.plan_num = index + 1
      plan.save
  	end
	end

		private

		def highest_plan_num
      return self.job.plans.where(tab: self.tab).count;
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

		def check_for_valid_tab_name
      valid_tabs = ["Plans", "Shops", "Consultants", "Calcs & Misc"]
      if !valid_tabs.include?(self.tab)
        errors.add(:tab, "isni't a valid tab")
      end
    end

		def check_for_duplicate_plan_num
			p = Plan.find_all_by_job_id_and_tab(self.job_id, self.plan_num)
	  	p.each do |plan|
	  		next if (plan.id == self.id) # Skip if current plan
  			if(plan.plan_num == self.plan_num)
  				errors.add(:plan_num, 'already exists')
  				return false
	  		end
	  	end
      return true
		end

	  def check_for_duplicate_plan_name_in_job
	  	p = Plan.find_all_by_job_id(self.job_id)
	  	p.each do |plan|
	  		if(plan.id == self.id)
	  			next
	  		end
        next if plan.tab != self.tab
  			if(plan.plan_name == self.plan_name)
  				errors.add(:plan_name, 'already exists')
  				return
	  		end
	  	end
	  end

    # Attempt to solve weird indexing bug
    def ensure_plans_have_unique_plan_nums(plans)
      puts "Attempting to ensure plans have unique plan nums"
      tabs = {}
      plans.each do |plan|
        if tabs[plan.tab] == nil
          tabs[plan.tab] = []
        else
          tabs[plan.tab] << plan
        end
      end
      tabs.keys do |key| # Go through all the plans per tab
        puts "Checking #{key}"
        plan_nums = {} # Keep track if we've seen a plan_num yet
        plans[key].each do |plan|
          plan_num = plan.plan_num
          if plan_nums[plan_num] == nil # If we've never seen the num, then good
            plan_nums[plan_num] = true
          elsif plan_nums[plan_num] == true # If we've seen the number before, then reorder.
            puts "ERROR: Redordering plan nums!"
            return reorder_plan_nums(plans[key])

          end
        end
      end
      return plans
    end

    def reorder_plan_nums(plans)
      plans.each_with_index do |plan, index|
        plan.plan_num == index + 1
      end
      return plans
    end
end
