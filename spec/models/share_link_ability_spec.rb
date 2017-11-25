require 'rails_helper'

RSpec.describe "ShareLink Permissions for", :type => :model do
  let(:share_link) { @share_link }

  let(:shared_jobs) { @shared_jobs }
  let(:shared_job) { shared_jobs.first }
  let(:shared_plan) { shared_job.plans.first }
  let(:shared_addendum) { shared_job.addendums.first }

  let(:unshared_jobs) { @unshared_jobs }
  let(:unshared_job) { unshared_jobs.first }
  let(:unshared_plan) { unshared_job.plans.first }

  JOB_PERMISSIONS = [
    {
      permissions: [:update],
      tabs: { 'plans': [:create, :update], 'addendums': [:update, :destroy] }
    }, {
      permissions: [],
      tabs: { 'addendums': [:update, :destroy] }
    }
  ]

  def generate_permissions_hash(jobs)
    jobs_permissions_hash = {}

    jobs.each_with_index do |job, i|
      jobs_permissions_hash[job.id] = JOB_PERMISSIONS[i] || JOB_PERMISSIONS[-1]
    end

    return { jobs: jobs_permissions_hash }
  end

  before(:all) do
    @share_link = create(:share_link)
    @shared_jobs = [ create(:job), create(:job) ]
    @unshared_jobs = [ create(:job), create(:job) ]

    @permissions_hash = generate_permissions_hash(@shared_jobs)
    @share_link.permissions.update_permissions(@permissions_hash)
  end

  describe "Job" do
    # Index
    it { expect(share_link).to be_able_to(:read_multiple, shared_jobs) }
    it { expect(share_link).not_to be_able_to(:read_multiple, unshared_jobs) }
    it { expect(share_link).not_to be_able_to(:read_multiple, Array) }

    # Show
    it { expect(share_link).to be_able_to(:read, shared_job) }
    it { expect(share_link).not_to be_able_to(:read, unshared_job) }
    it { expect(share_link).not_to be_able_to(:read, Job) }

    # Update
    it { expect(share_link).to be_able_to(:update, shared_job) }
    it { expect(share_link).not_to be_able_to(:update, unshared_job) }
    it { expect(share_link).not_to be_able_to(:update, Job) }
  end

  describe "Plan" do
    # Read
    it { expect(share_link).to be_able_to(:read, shared_plan) }
    it { expect(share_link).to be_able_to(:read, shared_addendum) }
    it { expect(share_link).not_to be_able_to(:read, unshared_plan) }
    it { expect(share_link).not_to be_able_to(:read, Plan) }

    # Create
    it { expect(share_link).to be_able_to(:create, shared_plan) }
    it { expect(share_link).not_to be_able_to(:create, shared_addendum) }
    it { expect(share_link).not_to be_able_to(:create, unshared_plan) }
    it { expect(share_link).not_to be_able_to(:create, Plan) }

    # Update
    it { expect(share_link).to be_able_to(:update, shared_plan) }
    it { expect(share_link).to be_able_to(:update, shared_addendum) }
    it { expect(share_link).not_to be_able_to(:update, unshared_plan) }
    it { expect(share_link).not_to be_able_to(:update, Plan) }

    # Destroy
    it { expect(share_link).to be_able_to(:destroy, shared_addendum) }
    it { expect(share_link).not_to be_able_to(:destroy, shared_plan) }
    it { expect(share_link).not_to be_able_to(:destroy, unshared_plan) }
    it { expect(share_link).not_to be_able_to(:destroy, Plan) }

    context "when shared job is archived" do
      let(:share_link) { @archived_share_link }
      let(:shared_jobs) { @archived_shared_jobs }
      let(:shared_plan) { @archived_shared_jobs.first.plans.first }

      before(:all) do
        @archived_share_link = create(:share_link)
        @archived_shared_jobs = [ create(:archived_job) ]

        archived_permissions_hash = generate_permissions_hash(@archived_shared_jobs)
        @archived_share_link.permissions.update_permissions(archived_permissions_hash)
      end

      it { expect(share_link).to be_able_to(:read, shared_plan) }
      it { expect(share_link).not_to be_able_to(:create, shared_plan) }
      it { expect(share_link).not_to be_able_to(:update, shared_plan) }
      it { expect(share_link).not_to be_able_to(:destroy, shared_plan) }
    end
  end

  describe "Document" do
    # Read
    it { expect(share_link).to be_able_to(:read, shared_plan.document) }
    it { expect(share_link).to be_able_to(:read, shared_addendum.document) }
    it { expect(share_link).not_to be_able_to(:read, unshared_plan.document) }
    it { expect(share_link).not_to be_able_to(:read, Document) }

    # Download
    it { expect(share_link).to be_able_to(:download, shared_plan.document) }
    it { expect(share_link).to be_able_to(:download, shared_addendum.document) }
    it { expect(share_link).not_to be_able_to(:download, unshared_plan.document) }
    it { expect(share_link).not_to be_able_to(:download, Document) }

    # Upload. Only users that are persisted.
    it { expect(share_link).to be_able_to(:upload, Document) }
    it { expect(ShareLink.new).not_to be_able_to(:upload, Document) }
  end
end
