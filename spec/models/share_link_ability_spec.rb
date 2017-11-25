require 'rails_helper'

RSpec.describe "ShareLink Permissions for", :type => :model do
  let(:share_link) { create(:share_link) }
  let(:job_without_permissions) { create(:job) }
  let(:jobs_with_permission) { [create(:job), create(:job)] }

  let(:archived_job) { user.archived_jobs.first }
  let(:not_my_job) { create(:user).open_jobs.first }
  let(:plan) { create(:plan, job: job) }
  let(:archived_plan) { create(:plan, job: archived_job) }
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
    # Read
    it { expect(user).to be_able_to(:read, plan) }
    it { expect(user).to be_able_to(:read, archived_plan) }
    it { expect(user).not_to be_able_to(:read, not_my_plan) }
    it { expect(user).not_to be_able_to(:read, Plan) }

    # Create
    it { expect(user).to be_able_to(:create, plan) }
    it { expect(user).not_to be_able_to(:create, not_my_plan) }
    it { expect(user).not_to be_able_to(:create, archived_plan) }
    it { expect(user).not_to be_able_to(:create, Plan) }

    # Update
    it { expect(user).to be_able_to(:update, plan) }
    it { expect(user).not_to be_able_to(:update, not_my_plan) }
    it { expect(user).not_to be_able_to(:update, archived_plan) }
    it { expect(user).not_to be_able_to(:update, Plan) }

    # Destroy
    it { expect(user).to be_able_to(:destroy, plan) }
    it { expect(user).not_to be_able_to(:destroy, not_my_plan) }
    it { expect(user).not_to be_able_to(:destroy, archived_plan) }
    it { expect(user).not_to be_able_to(:destroy, Plan) }
  end

  describe "Document" do
    # Read
    it { expect(user).to be_able_to(:read, plan.document) }
    it { expect(user).not_to be_able_to(:read, not_my_plan.document) }
    it { expect(user).not_to be_able_to(:read, Document) }

    # Download
    it { expect(user).to be_able_to(:download, plan.document) }
    it { expect(user).not_to be_able_to(:download, not_my_plan.document) }
    it { expect(user).not_to be_able_to(:download, Document) }

    # Upload. Only users that are persisted.
    it { expect(user).to be_able_to(:upload, Document) }
    it { expect(build(:user)).not_to be_able_to(:upload, Document) }
  end
end
