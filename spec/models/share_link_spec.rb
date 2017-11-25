require 'rails_helper'

RSpec.describe ShareLink, :type => :model do
  let(:share_link) { @share_link }

  before(:all) do
    @share_link = create(:share_link)
  end

  it { expect(subject).to belong_to(:user) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:user_id) }

    it "should check for duplicate name for user" do
      new_share_link = ShareLink.new(name: share_link.name)
      new_share_link.user_id = share_link.user.id

      expect(new_share_link).not_to be_valid
    end
  end

  describe "abilities" do
    it { expect(share_link).to respond_to(:can?) }
    it { expect(share_link).to respond_to(:cannot?) }
  end

  describe "#create_token" do
    # Make sure share_link has a token before continuing.
    after(:all) { @share_link.valid? }

    context "when token is set" do
      let(:token) { @token }

      before(:all) do
        @token = 'token'
        @share_link.token = @token
        @share_link.valid?
      end

      it { expect(share_link.token).to eq(token) }
    end

    context "when token is not set" do
      before(:all) do
        @share_link.token = nil
        @share_link.valid?
      end

      it { expect(share_link.token).not_to be_nil }
    end
  end

  describe "#create_blank_permissions" do
    after(:all) { @share_link.save if @share_link.permissions.nil? }

    it "generates permissions after save" do
      share_link.permissions.destroy
      share_link.reload

      expect(share_link.permissions).to be_nil
      share_link.save
      expect(share_link.permissions).not_to be_nil
    end
  end
end
