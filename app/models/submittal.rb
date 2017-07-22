class Submittal < ActiveRecord::Base
  attr_accessible :data, :user_id, :plan_id, :is_accepted
  belongs_to :plan
  belongs_to :user
  serialize :data, JSON
end
