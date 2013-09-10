# == Schema Information
#
# Table name: shares
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  job_id      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  token       :string(255)
#  sharer_id   :integer
#  can_reshare :boolean          default(FALSE)
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
