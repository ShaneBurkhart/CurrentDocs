require 'rails_helper'

RSpec.describe "User Permissions for", :type => :model do
  let(:user) { @user }
  let(:jobs) { user.open_jobs }
  let(:job) { jobs.first }
  let(:plan) { job.plans.first }
  let(:archived_job) { user.archived_jobs.first }
  let(:archived_plan) { archived_job.plans.first }

  let(:not_me_user) { @not_me_user }
  let(:not_my_jobs) { not_me_user.open_jobs }
  let(:not_my_job) { not_my_jobs.first }
  let(:not_my_plan) { not_my_job.plans.first }

  before(:all) do
    @user = create(:user)
    @job = @user.open_jobs.first
    @not_me_user = create(:user)
  end

  describe "Job" do
    # Index
    it { expect(user).to be_able_to(:read_multiple, jobs) }
    it { expect(user).not_to be_able_to(:read_multiple, not_my_jobs) }
    it { expect(user).not_to be_able_to(:read_multiple, Array) }

    # Show
    it { expect(user).to be_able_to(:read, job) }
    it { expect(user).not_to be_able_to(:read, not_my_job) }
    it { expect(user).not_to be_able_to(:read, Job) }

    # Create
    it { expect(user).to be_able_to(:create, job) }
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

    # Share
    it { expect(user).to be_able_to(:share, job) }
    it { expect(user).not_to be_able_to(:share, not_my_job) }
    it { expect(user).not_to be_able_to(:share, Job) }
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

  describe "JobPermission" do
    before(:all) do
      @share_link = create(:share_link, user: @user)
      @job_permission = @share_link.permissions.find_or_create_job_permission(@job)
    end

    # Update
    it { expect(user).to be_able_to(:update, @job_permission) }
    # Destroy
    it { expect(user).to be_able_to(:destroy, @job_permission) }

    context "when the job isn't the user's" do
      before(:all) do
        @job_permission = @share_link.permissions
          .find_or_create_job_permission(create(:job_without_plans))
      end

      it { expect(user).not_to be_able_to(:update, @job_permission) }
      it { expect(user).not_to be_able_to(:destroy, @job_permission) }
    end

    context "when permissions isn't for a user's share link" do
      before(:all) do
        @job_permission = create(:share_link).permissions
          .find_or_create_job_permission(@job)
      end

      it { expect(user).not_to be_able_to(:update, @job_permission) }
      it { expect(user).not_to be_able_to(:destroy, @job_permission) }
    end
  end
end
