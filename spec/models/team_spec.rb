require 'rails_helper'

RSpec.describe Team, :type => :model do
  let(:team) { @team }
  let(:user) { @user }

  before(:all) do
    @team = create(:team)
    @user = create(:user)
  end

  it { expect(subject).to have_many(:jobs) }
  it { expect(subject).to have_many(:team_users) }
  it { expect(subject).to have_many(:users).through(:team_users) }
  it { expect(subject).to have_many(:share_links) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:name) }
  end

  describe "#add_user" do
    it "adds the user to the team" do
      expect(team.add_user(user)).to be(true)
      expect(team.users).to include(user)
    end

    context "when user is nil" do
      it { expect(team.add_user(nil)).to be(false) }
    end
  end
end
