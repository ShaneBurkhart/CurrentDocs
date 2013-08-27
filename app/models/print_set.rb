class PrintSet < ActiveRecord::Base
  belongs_to :job
  has_many :plans
end
