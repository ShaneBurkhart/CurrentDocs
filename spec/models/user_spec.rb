require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { @user }

  before(:all) { @user = create(:user) }

  it { expect(subject).to have_many(:jobs) }
  it { expect(subject).to have_many(:open_jobs).conditions(is_archived: false) }
  it { expect(subject).to have_many(:archived_jobs).conditions(is_archived: true) }
  it { expect(subject).to have_many(:team_users) }
  it { expect(subject).to have_many(:teams).through(:team_users) }
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

  describe "#new_share_link" do
    it { expect(user.new_share_link).to be_a(ShareLink) }
    it { expect(user.new_share_link.user_id).to eq(user.id) }
  end

  describe "#new_job" do
    it { expect(user.new_job).to be_a(Job) }
    it { expect(user.new_job.user_id).to eq(user.id) }
  end
end
