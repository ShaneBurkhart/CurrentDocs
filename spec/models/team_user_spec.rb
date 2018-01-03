require 'rails_helper'

RSpec.describe TeamUser, :type => :model do
  let(:team_user) { @team_user }

  before(:all) { @team_user = create(:team_user) }

  it { expect(subject).to belong_to(:team) }
  it { expect(subject).to belong_to(:user) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:team_id) }
    it { expect(subject).to validate_presence_of(:user_id) }

    it "should check for duplicate user on team" do
      new_team_user = build(
        :team_user,
        user_id: team_user.user.id,
        team_id: team_user.team.id
      )

      expect(new_team_user).not_to be_valid
    end
  end
end
