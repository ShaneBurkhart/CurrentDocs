require 'rails_helper'

RSpec.describe PlanTabPermission, :type => :model do
  let(:plan_tab_permission) { build(:plan_tab_permission) }

  it { expect(subject).to belong_to(:job_permission) }

  describe "validations" do
    subject { plan_tab_permission }
    it { expect(subject).to validate_presence_of(:tab) }
    it { expect(subject).to validate_presence_of(:job_permission_id) }

    it "should check for valid tab" do
      invalid = build(:plan_tab_permission, tab: "asdfasdf")
      valid = build(:plan_tab_permission, tab: "Plans")

      expect(invalid).not_to be_valid
      expect(valid).to be_valid
    end
  end

  describe "#tab=" do
    it "downcases assignment value" do
      plan_tab_permission.tab = "AdDenDumS"
      expect(plan_tab_permission.tab).to eq("addendums")
    end

    it "assigns nil" do
      plan_tab_permission.tab = nil
      expect(plan_tab_permission.tab).to be_nil
    end
  end

  describe "#update_permissions" do
    let(:permissions) { [:can_create, :can_update, :can_destroy] }
    let(:action) { plan_tab_permission.update_permissions(permissions) }
    before(:each) { action }

    it { expect(plan_tab_permission.can_create).to be(true) }
    it { expect(plan_tab_permission.can_update).to be(true) }
    it { expect(plan_tab_permission.can_destroy).to be(true) }
    it { expect(action).to be(true) }

    context "when :create is not set" do
      let(:permissions) { [:can_update, :can_destroy] }
      it { expect(plan_tab_permission.can_create).to be(false) }
      it { expect(action).to be(true) }
    end

    context "when :update is not set" do
      let(:permissions) { [:can_create, :can_destroy] }
      it { expect(plan_tab_permission.can_update).to be(false) }
      it { expect(action).to be(true) }
    end

    context "when :destroy is not set" do
      let(:permissions) { [:can_create, :can_update] }
      it { expect(plan_tab_permission.can_destroy).to be(false) }
      it { expect(action).to be(true) }
    end
  end
end
