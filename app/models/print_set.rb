class PrintSet < ActiveRecord::Base
  attr_accessible :job_id
  belongs_to :job
  has_many :plans
end
