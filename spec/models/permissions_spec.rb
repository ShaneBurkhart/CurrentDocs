require 'rails_helper'

RSpec.describe Permissions, :type => :model do
  let(:permissions) { create(:blank_permissions) }

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
    let(:jobs) { [ create(:job), create(:job) ] }
    let(:permissions_for_tabs) { { 'plans': [:update], 'addendums': [:create, :update] } }
    let(:permissions_for_jobs) { {
      jobs[0].id => { permissions: [:update], tabs: permissions_for_tabs },
      jobs[1].id => { permissions: [], tabs: permissions_for_tabs },
    } }
    let(:action) do
      permissions.update_permissions({ jobs: permissions_for_jobs })
    end
    before(:each) { action }

    it { expect(permissions.job_permissions.count).to eq(2) }
    it { expect(action).to be(true) }

    describe "#update_permissions gets called on JobPermission instances" do
      before(:each) do
        allow_any_instance_of(JobPermission)
          .to receive(:update_permissions)
          .with(permissions_for_jobs[jobs[0].id])
        allow_any_instance_of(JobPermission)
          .to receive(:update_permissions)
          .with(permissions_for_jobs[jobs[1].id])

        action
      end

      it { expect(action).to be(true) }
    end

    context "with no job permissions" do
      let(:permissions_for_jobs) { [] }

      it { expect(action).to be(true) }
      it { expect(permissions.job_permissions.count).to eq(0) }
    end

    context "with nil job permissions" do
      let(:permissions_for_jobs) { nil }

      it { expect(action).to be(true) }
      it { expect(permissions.job_permissions.count).to eq(0) }
    end

    context "when removing a job permission" do
      let(:new_permissions_for_jobs) { {
        jobs[0].id => { permissions: [:update], tabs: permissions_for_tabs },
      } }

      it { expect(action).to be(true) }

      it "has only one job permission" do
        expect(permissions.job_permissions.count).to eq(2)

        permissions.update_permissions({ jobs: new_permissions_for_jobs })

        expect(permissions.job_permissions.count).to eq(1)
      end
    end
  end
end
