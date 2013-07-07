# == Schema Information
#
# Table name: jobs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Job < ActiveRecord::Base
	belongs_to :user
	has_many :plans
  has_many :shares
  has_many :shared_users, through: :shares, source: :user
	has_many :assignments
  attr_accessible :name, :user_id, :plan_ids
  validates :user_id, presence: true
  validates :name, presence: true#, uniqueness: true
  validate :check_for_dubplicate_name_for_single_user

	private

	  def check_for_dubplicate_name_for_single_user
	  	j = Job.find_all_by_user_id(self.user_id)
	  	j.each do |job|
  			if(job.name == self.name)
  				errors.add(:name, 'already exists')
  				return
	  		end
	  	end
	  end

end
