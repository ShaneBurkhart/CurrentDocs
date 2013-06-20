# == Schema Information
#
# Table name: assignments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Assignment < ActiveRecord::Base
	belongs_to :job
	belongs_to :user
  attr_accessible :job_id, :user_id
  validates :job_id, :user_id, presence: true
end
