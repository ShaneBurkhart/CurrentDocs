require 'spec_helper'

describe Plan do

	before do
		@plan = Plan.create(page_name: "Page", filename: "file.pdf", job_id: 1)
	end
  
  it "should respond to job" do
  	@plan.should respond_to :job
  end

  it "should respond to page_name" do
  	@plan.should respond_to :page_name
  end

  it "should respond to filename" do
  	@plan.should respond_to :filename
  end

  it "should not have duplicate page_name for one job" do
  	@one = Plan.new(page_name: "Page", filename: "file.php", job_id: 1)
  	@one.should_not be_valid
  end

end
