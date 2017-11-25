require 'rails_helper'

RSpec.describe JobPermission, :type => :model do
  let(:job_permission) { build(:job_permission) }

  it { expect(subject).to belong_to(:job) }
  it { expect(subject).to belong_to(:permissions) }
  it { expect(subject).to have_many(:plan_tab_permissions) }

  describe "validations" do
    subject { job_permission }
    it { expect(subject).to validate_presence_of(:job_id) }
    it { expect(subject).to validate_presence_of(:permissions_id) }
  end

  # permissions_hash is a tree of permissions:
  #   {
  #     'permissions': []
  #     'tabs': {
  #       'plans': [:update]
  #       'addendums': []
  #     }
  #   }
  describe "#update_permissions" do
    let(:job_can_permissions) { [:update] }
    let(:permissions_for_tabs) { { "plans": [:update], "addendums": [:create] } }
    let(:action) do
      job_permission.update_permissions({
        permissions: job_can_permissions,
        tabs: permissions_for_tabs
      })
    end
    before(:each) { action }

    it { expect(job_permission.can_update).to be(true) }
    it { expect(job_permission.plan_tab_permissions.count).to eq(2) }
    it { expect(action).to be(true) }

    describe "#update_permissions gets called on PlanTabPermission instances" do
      before(:each) do
        allow_any_instance_of(PlanTabPermission)
          .to receive(:update_permissions)
          .with(permissions_for_tabs["plans"])
        allow_any_instance_of(PlanTabPermission)
          .to receive(:update_permissions)
          .with(permissions_for_tabs["addendums"])

        action
      end

      it { expect(action).to be(true) }
    end

    context "with no job permissions" do
      let(:job_can_permissions) { [] }
      it { expect(job_permission.can_update).to be(false) }
      it { expect(action).to be(true) }
    end

    context "with nil job permissions" do
      let(:job_can_permissions) { nil }
      it { expect(job_permission.can_update).to be(false) }
      it { expect(action).to be(true) }
    end

    context "with nil tab permissions" do
      let(:permissions_for_tabs) { nil }
      it { expect(job_permission.plan_tab_permissions.count).to eq(0) }
      it { expect(action).to be(true) }
    end

    context "when removing a tab permission" do
      let(:new_permissions_for_tabs) { { "addendums": [:create] } }

      it { expect(action).to be(true) }

      it "has only one plan tab permission" do
        job_permission.update_permissions({
          permissions: job_can_permissions,
          tabs: new_permissions_for_tabs
        })
        expect(job_permission.plan_tab_permissions.count).to eq(1)
      end
    end
  end
end
