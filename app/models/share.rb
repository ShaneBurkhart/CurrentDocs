# == Schema Information
#
# Table name: shares
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  job_id     :integer
#  accepted   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Share < ActiveRecord::Base
	belongs_to :job
	belongs_to :user
  attr_accessible :accepted, :job_id, :user_id #invited user
  #job.user is the inviter
end
