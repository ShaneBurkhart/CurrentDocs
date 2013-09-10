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
  has_one :print_set
	has_many :plans
  has_many :shares
  has_many :shared_users, through: :shares, source: :user
  attr_accessible :name, :user_id
  validates :user_id, presence: true
  validates :name, presence: true#, uniqueness: true
  validate :check_for_dubplicate_name_for_single_user

  before_create :default_print_set
  after_create :increment_owner
  after_create :check_free_trial

  before_destroy :destroy_plans
	before_destroy :destroy_shares

	private

    def check_free_trial
      user.start_subscription if user.free_trial_ended?
    end

    def increment_owner
      self.user.increment! :total_jobs
      self.user.save
    end

    def default_print_set
      self.print_set = PrintSet.new job_id: self.id
    end

		def destroy_shares
			self.shares.each do |share|
				share.destroy
			end
		end

		def destroy_plans
			self.plans.each do |plan|
				plan.destroy
			end
		end

	  def check_for_dubplicate_name_for_single_user
	  	j = Job.find_all_by_user_id_and_name(self.user_id, self.name)
			errors.add(:name, 'already exists') unless j.count < 1
	  end

end
