require 'rails_helper'

RSpec.describe Job, :type => :model do
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to have_many(:plans) }
  it { expect(subject).to have_many(:share_links) }

  describe "validations" do
    subject { create(:job) }
    it { expect(subject).to validate_presence_of(:user_id) }
    it { expect(subject).to validate_presence_of(:name) }

    it "should check for duplicate name for user" do
      new_job = build(:job, name: subject.name, user: subject.user)

      expect(new_job).not_to be_valid
    end
  end
end
