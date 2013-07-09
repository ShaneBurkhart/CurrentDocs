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

describe Share do

	before(:each) do
		@share = FactoryGirl.create :share
	end

  it{ @share.should respond_to :job }
  it{ @share.should respond_to :user }
  it{ @share.should respond_to :accepted }
  it{ @share.should respond_to :token }

  it "should have user_id" do
    Share.create(job_id: @share.job_id).should_not be_valid
  end
  it "should have job_id" do
    Share.create(user_id: @share.user_id).should_not be_valid
  end

  it "should not have a duplicate" do
    Share.create(job_id: @share.job_id, user_id: @share.user_id).should_not be_valid
  end

end
