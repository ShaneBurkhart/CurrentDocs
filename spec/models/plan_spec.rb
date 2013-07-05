# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  plan_name  :string(255)
#  filename   :string(255)
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Plan do

	before(:each) do
		@plan = Plan.create(plan_num: 1, plan_name: "Page", filename: "file.pdf", job_id: 1)
	end

  it "should respond to job" do
  	@plan.should respond_to :job
  end

  it "should respond to plan_num" do
    @plan.should respond_to :plan_num
  end

  it "should respond to plan_name" do
  	@plan.should respond_to :plan_name
  end

  it "should respond to filename" do
  	@plan.should respond_to :filename
  end

  it "should have plan_num to be valid" do
    @plan.plan_num = nil
    @plan.should_not be_valid
  end

  it "should have plan_name to be valid" do
    @plan.plan_name = nil
    @plan.should_not be_valid
  end

  it "should have job_id to be valid" do
    @plan.job_id = nil
    @plan.should_not be_valid
  end

  it "should not have duplicate plan_name for one job" do
  	@one = Plan.new(plan_name: "Page", filename: "file.php", job_id: 1)
  	@one.should_not be_valid
  end

end
