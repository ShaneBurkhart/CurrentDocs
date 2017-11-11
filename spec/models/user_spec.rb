require 'rails_helper'

RSpec.describe User, :type => :model do
  it { expect(subject).to have_many(:jobs) }

  describe "validations" do
    subject { create(:user) }
    it { expect(subject).to validate_presence_of(:first_name) }
    it { expect(subject).to validate_presence_of(:last_name) }
    it { expect(subject).to validate_presence_of(:company) }
  end

  it "should generate authentication_token before validation" do
    user = build(:user, authentication_token: nil)
    user.valid?
    expect(user.authentication_token).not_to be_nil
  end
end
