require 'rails_helper'

RSpec.describe JobPermission, :type => :model do
  let(:job_permission) { @job_permission }

  before(:all) do
    @job_permission = create(:job_permission)
  end

  it { expect(subject).to belong_to(:job) }
  it { expect(subject).to belong_to(:permissions) }
  it { expect(subject).to have_many(:plan_tab_permissions) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:job_id) }
    it { expect(subject).to validate_presence_of(:permissions_id) }
  end

  describe "#find_or_create_tab_permission" do
    let(:action) { job_permission.find_or_create_tab_permission(tab) }

    context "when tab is not a valid tab" do
      let(:tab) { 'invalid_tab' }

      it { expect(action).to be_nil }
    end

    context "when tab permission doesn't exist" do
      let(:tab) { 'addendums' }

      before(:all) do
        @job_permission.plan_tab_permissions.destroy_all
      end

      context "when save is true" do
        it "creates a new PlanTabPermission" do
          expect(action).to be_a(PlanTabPermission)
          expect(action.tab).to eq(tab)
          expect(action.job_permission_id).to eq(job_permission.id)
          expect(job_permission.plan_tab_permissions.count).to eq(1)
        end
      end

      context "when save is false" do
        let(:action) { job_permission.find_or_create_tab_permission(tab, false) }

        it "returns a new instance of PlanTabPermission but doesn't save" do
          expect(action).to be_a_new(PlanTabPermission)
          expect(action.tab).to eq(tab)
          expect(action.job_permission_id).to eq(job_permission.id)
        end
      end
    end

    context "when tab permission does exist" do
      let(:tab) { @tab }
      let(:plan_tab_permission) { @plan_tab_permission }

      before(:all) do
        @tab = 'addendums'
        @job_permission.plan_tab_permissions.destroy_all
        @plan_tab_permission = create(
          :plan_tab_permission, tab: @tab, job_permission_id: @job_permission.id
        )
      end

      it "returns the existing tab permission" do
        expect(action).to be_a(PlanTabPermission)
        expect(action.id).to eq(plan_tab_permission.id)
      end
    end
  end

  # permissions_hash is a tree of permissions:
  #   {
  #     'permissions': []
  #     'tabs': {
  #       'plans': [:can_update]
  #       'addendums': []
  #     }
  #   }
  describe "#update_permissions" do
    let(:job_can_permissions) { [:can_update] }
    let(:permissions_for_tabs) { {
      "plans": [:can_update], "addendums": [:can_create]
    } }
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
