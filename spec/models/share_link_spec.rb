require 'rails_helper'

RSpec.describe ShareLink, :type => :model do
  let(:share_link) { create(:share_link) }

  it { expect(subject).to belong_to(:user) }

  describe "validations" do
    subject { share_link }
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:user_id) }

    it "should check for duplicate name for user" do
      new_share_link = build(:share_link, name: subject.name, user: subject.user)
      expect(new_share_link).not_to be_valid
    end
  end

  describe "abilities" do
    it { expect(subject).to respond_to(:can?) }
    it { expect(subject).to respond_to(:cannot?) }
  end

  describe "#create_token" do
    before(:each) do
      @initial_token = share_link.token
      share_link.valid?
    end

    context "when token is set" do
      it { expect(share_link.token).to eq(@initial_token) }
    end

    context "when token is not set" do
      let(:share_link) { build(:share_link) }
      it { expect(share_link.token).not_to be_nil }
      it { expect(share_link.token).not_to eq(@initial_token) }
    end
  end

  describe "#create_blank_permissions" do
    let(:share_link) { build(:share_link) }
    before(:each) do
      @initial_permissions = share_link.permissions
      share_link.save
    end

    it { expect(@initial_token).to be_nil }
    it { expect(share_link.permissions).not_to be_nil }
  end
end
