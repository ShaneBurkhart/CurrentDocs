class Submittal < ActiveRecord::Base
  attr_accessible :data, :user_id, :plan_id, :job_id, :is_accepted
  belongs_to :user
  # Once accepted, the submittal gets added to a plan
  belongs_to :plan
  # Before accepted, the submittal doesn't have a plan, so we need to put it under
  # a job for review by the owner.
  belongs_to :job
  # Keep data general so we can customize the submittal form easily
  serialize :data, JSON
end
