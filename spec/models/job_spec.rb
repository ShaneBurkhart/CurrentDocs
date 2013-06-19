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

require 'spec_helper'

describe Job do

	before do
		@job = Job.create(name: "Job", user_id: 1)
	end
  
  it "should respond to name" do
  	@job.should respond_to :name
  end

  it "should respond to user" do
  	@job.should respond_to :user
  end

	it "should respond to plans" do
  	@job.should respond_to :plans
  end

  it "should respond to assignments" do
    @job.should respond_to :assignments
  end

  it "should have a name" do
  	j = Job.new(user_id: 1)
  	j.should_not be_valid
  end

  it "should have a user_id" do
		j = Job.new(name: "Name")
  	j.should_not be_valid
  end

  it "should not have duplicate name for one user" do
    one = Job.new(name: "Job", user_id: 1)
    one.should_not be_valid
  end

end
