require 'rails_helper'

RSpec.describe "User Permissions for", :type => :model do
  let(:user) { create(:user) }

  describe "Job" do
    # Index
    it { expect(user).to be_able_to(:read_multiple, user.jobs) }
    it { expect(user).not_to be_able_to(:read_multiple, create(:user).jobs) }

    # Show
    it { expect(user).to be_able_to(:read, user.jobs.first) }
    it { expect(user).not_to be_able_to(:read, create(:user).jobs.first) }

    # Create
    it { expect(user).to be_able_to(:create, Job) }

    # Update
    it { expect(user).to be_able_to(:update, user.jobs.first) }
    it { expect(user).not_to be_able_to(:update, create(:user).jobs.first) }

    # Destroy
    it { expect(user).to be_able_to(:destroy, user.jobs.first) }
    it { expect(user).not_to be_able_to(:destroy, create(:user).jobs.first) }
  end

  describe "Document" do
    let(:job) { user.open_jobs.first }
    let(:plan) { create(:plan, job: job) }

    # Download
    it { expect(user).to be_able_to(:download, plan.document) }
    it { expect(user).not_to be_able_to(:download, create(:plan).document) }
  end
end
