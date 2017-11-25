require 'rails_helper'

RSpec.describe Permissions, :type => :model do
  let(:permissions) { @permissions }

  before(:all) do
    @permissions = create(:blank_permissions)
  end

  it { expect(subject).to belong_to(:authenticatable) }
  it { expect(subject).to have_many(:job_permissions) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:authenticatable_id) }
    it { expect(subject).to validate_presence_of(:authenticatable_type) }
  end

  # permissions_hash is a tree of permissions:
  # If a value is nil, then it should be destroyed.
  # {
  #   jobs: {
  #     12: {
  #       'permissions': [:update]
  #       'tabs': {
  #         'plans': [:create]
  #         'addendums': [:update, :create]
  #       }
  #     },
  #     53: {
  #       'permissions': []
  #       'tabs': { 'plans': [:update] }
  #     }
  #   }
  # }
  describe "#update_permissions" do
    let(:jobs) { @jobs }

    let(:permissions_for_tabs) { @permissions_for_tabs }
    let(:permissions_for_jobs) { @permissions_for_jobs }

    let(:permissions_hash) { @permissions_hash }

    before(:all) do
      @jobs = [ create(:job), create(:job) ]
      @permissions_for_tabs = {
        'plans': [:update], 'addendums': [:create, :update]
      }
      @permissions_for_jobs = {
        @jobs[0].id => { permissions: [:update], tabs: @permissions_for_tabs },
        @jobs[1].id => { permissions: [], tabs: @permissions_for_tabs },
      }
      @permissions_hash = { jobs: @permissions_for_jobs }

      @permissions.update_permissions(@permissions_hash)
    end

    context "with full permissions" do
      before(:all) do
        @permissions.update_permissions(@permissions_hash)
      end

      it { expect(permissions.job_permissions.count).to eq(2) }

      it "receives JobPermission#update_permissions for each job" do
        expect_any_instance_of(JobPermission)
          .to receive(:update_permissions)
          .with(@permissions_for_jobs[@jobs[0].id])
        expect_any_instance_of(JobPermission)
          .to receive(:update_permissions)
          .with(@permissions_for_jobs[@jobs[1].id])

        @permissions.update_permissions(@permissions_hash)
      end
    end

    context "with no job permissions" do
      before(:all) do
        @permissions.update_permissions({ jobs: {} })
      end

      it { expect(permissions.job_permissions.count).to eq(0) }
    end

    context "with nil job permissions" do
      before(:all) do
        @permissions.update_permissions({ jobs: nil })
      end

      it { expect(permissions.job_permissions.count).to eq(0) }
    end

    context "when removing a job permission" do
      let(:new_permissions_hash) { {
        jobs: {
          jobs[0].id => { permissions: [:update], tabs: permissions_for_tabs },
        }
      } }

      before(:all) do
        @permissions.update_permissions(@permissions_hash)
      end

      it "has only one job permission" do
        expect(permissions.job_permissions.count).to eq(2)

        permissions.update_permissions(new_permissions_hash)

        expect(permissions.job_permissions.count).to eq(1)
      end
    end
  end
end
