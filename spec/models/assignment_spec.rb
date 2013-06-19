require 'spec_helper'

describe Assignment do
  
	before do
		@assignment = Assignment.create(user_id: 1, job_id: 1)
	end

  it "should respond to user" do
  	@assignment.should respond_to :user
  end

  it "should respond to job" do
		@assignment.should respond_to :job
  end

  it "should not be valid" do
  	a = Assignment.new()
  	a.should_not be_valid
  end

end
