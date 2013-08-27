class PrintSet < ActiveRecord::Base
  has_one :job
  has_many :plans
end
