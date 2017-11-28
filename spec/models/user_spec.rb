require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { @user }

  before(:all) { @user = create(:user) }

  it { expect(subject).to have_many(:jobs) }
  it { expect(subject).to have_many(:open_jobs) }
  it { expect(subject).to have_many(:archived_jobs) }
  it { expect(subject).to have_many(:share_links) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:first_name) }
    it { expect(subject).to validate_presence_of(:last_name) }
  end

  describe "abilities" do
    it { expect(user).to respond_to(:can?) }
    it { expect(user).to respond_to(:cannot?) }
  end

  describe "roles" do
    # We don't have shared users yet so all Users are owners.
    it { expect(user.owner?).to be(true) }
    it { expect(user.share_link?).to be(false) }
  end
end
