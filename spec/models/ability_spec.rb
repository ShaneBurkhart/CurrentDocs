require 'rails_helper'

RSpec.describe "User Permissions for", :type => :model do
  let(:user) { create(:user) }
  let(:job) { user.open_jobs.first }
  let(:not_my_job) { create(:user).open_jobs.first }
  let(:plan) { create(:plan, job: job) }
  let(:not_my_plan) { create(:plan, job: not_my_job) }

  describe "Job" do
    # Index
    it { expect(user).to be_able_to(:read_multiple, user.jobs) }
    it { expect(user).not_to be_able_to(:read_multiple, create(:user).jobs) }
    it { expect(user).not_to be_able_to(:read_multiple, Array) }

    # Show
    it { expect(user).to be_able_to(:read, job) }
    it { expect(user).not_to be_able_to(:read, not_my_job) }
    it { expect(user).not_to be_able_to(:read, Job) }

    # Create. The instance passed to :create needs to have a user_id
    it { expect(user).to be_able_to(:create, build(:job, user: user)) }
    it { expect(user).not_to be_able_to(:create, not_my_job) }
    it { expect(user).not_to be_able_to(:create, Job) }

    # Update
    it { expect(user).to be_able_to(:update, job) }
    it { expect(user).not_to be_able_to(:update, not_my_job) }
    it { expect(user).not_to be_able_to(:update, Job) }

    # Destroy
    it { expect(user).to be_able_to(:destroy, job) }
    it { expect(user).not_to be_able_to(:destroy, not_my_job) }
    it { expect(user).not_to be_able_to(:destroy, Job) }
  end

  describe "Plan" do
    # Create
    it { expect(user).to be_able_to(:create, plan) }
    it { expect(user).not_to be_able_to(:create, not_my_plan) }
    it { expect(user).not_to be_able_to(:create, Plan) }

    # Update
    it { expect(user).to be_able_to(:update, plan) }
    it { expect(user).not_to be_able_to(:update, not_my_plan) }
    it { expect(user).not_to be_able_to(:update, Plan) }

    # Destroy
    it { expect(user).to be_able_to(:destroy, plan) }
    it { expect(user).not_to be_able_to(:destroy, not_my_plan) }
    it { expect(user).not_to be_able_to(:destroy, Plan) }
  end

  describe "Document" do
    # Download
    it { expect(user).to be_able_to(:download, plan.document) }
    it { expect(user).not_to be_able_to(:download, not_my_plan.document) }
    it { expect(user).not_to be_able_to(:download, Document) }

    # Upload. Only users that are persisted.
    it { expect(user).to be_able_to(:upload, Document) }
    it { expect(build(:user)).not_to be_able_to(:upload, Document) }
  end
end
