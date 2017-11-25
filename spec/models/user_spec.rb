require 'rails_helper'

RSpec.describe User, :type => :model do
  it { expect(subject).to have_many(:jobs) }
  it { expect(subject).to have_many(:open_jobs) }
  it { expect(subject).to have_many(:archived_jobs) }
  it { expect(subject).to have_many(:share_links) }

  describe "validations" do
    subject { create(:user) }
    it { expect(subject).to validate_presence_of(:first_name) }
    it { expect(subject).to validate_presence_of(:last_name) }
  end

  describe "abilities" do
    it { expect(subject).to respond_to(:can?) }
    it { expect(subject).to respond_to(:cannot?) }
  end
end
