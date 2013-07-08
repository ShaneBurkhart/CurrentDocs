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
  attr_accessible :accepted, :job_id, :user_id, #invited user
  	:token
  #job.user is the inviter
  before_create :generate_token

  private

	  def generate_token
	    self.token = loop do
	      random_token = SecureRandom.urlsafe_base64(nil, false)
	      break random_token unless Share.where(token: random_token).exists?
	    end
	  end

end
