require 'rails_helper'

RSpec.describe ShareLink, :type => :model do
  let(:share_link) { create(:share_link) }

  it { expect(subject).to belong_to(:user) }

  describe "validations" do
    subject { share_link }
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:token) }
    it { expect(subject).to validate_presence_of(:user_id) }

    it "should check for duplicate name for user" do
      new_share_link = build(:share_link, name: subject.name, user: subject.user)
      expect(new_share_link).not_to be_valid
    end
  end

  describe "#create_token" do
    before(:each) do
      @initial_token = share_link.token
      share_link.validate
    end

    context "when token is set" do
      let(:share_link) { share_link }
      it { expect(share_link.token).to eq(@initial_token) }
    end

    context "when token is not set" do
      let(:share_link) { build(:share_link) }
      it { expect(share_link.token).not_to be_nil }
      it { expect(share_link.token).not_to eq(@initial_token) }
    end
  end
end
