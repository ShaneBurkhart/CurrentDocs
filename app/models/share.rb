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

  validates :token, uniqueness: true
  validates :job_id, :user_id, presence: true
  validate :check_existance

  private

  	def check_existance
			errors.add(:job_id, 'Share already exists') unless Share.find_by_job_id_and_user_id(self.job_id, self.user_id).nil?
  	end

	  def generate_token
	    self.token = loop do
	      random_token = SecureRandom.urlsafe_base64(nil, false)
	      break random_token unless Share.where(token: random_token).exists?
	    end
	  end

end
