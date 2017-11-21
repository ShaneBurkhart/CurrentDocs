require 'rails_helper'

RSpec.describe Plan, :type => :model do
  let(:plan) { create(:plan) }

  it { expect(subject).to belong_to(:job) }
  it { expect(subject).to have_one(:plan_document) }
  it { expect(subject).to have_one(:document) }
  it { expect(subject).to have_many(:plan_document_histories) }
  it { expect(subject).to have_many(:document_histories) }

  describe "validations" do
    subject { plan }
    it { expect(subject).to validate_presence_of(:job_id) }
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:tab) }
    it { expect(subject).to validate_presence_of(:order_num).on(:update) }
    it { expect(subject).to validate_length_of(:status).is_at_most(50) }
    it { expect(subject).to validate_length_of(:description).is_at_most(20000) }
    it { expect(subject).to validate_length_of(:code).is_at_most(12) }

    it "should check for duplicate name for tab in job" do
      new_plan = build(
        :plan,
        job_id: subject.job_id,
        name: subject.name,
        tab: subject.tab
      )

      expect(new_plan).not_to be_valid
    end

    it "should check for valid tab" do
      invalid_plan = build(:plan, tab: "asdfasdf")
      valid_plan = build(:plan, tab: "Plans")

      expect(invalid_plan).not_to be_valid
      expect(valid_plan).to be_valid
    end
  end

  describe "before_create #add_to_end_of_list" do
    let(:job) { create(:job) }

    it "adds plan to end of list" do
      plan = build(:plan, tab: "plans", job: job)
      job_plans_count = job.plans.count

      expect(plan.order_num).to be_nil
      plan.save
      expect(plan.order_num).to eq(job_plans_count)
    end
  end

  describe "before_destroy #delete_plan_in_list" do
    let(:plan_count) { 5 }
    let(:job) { create(:job, plan_count: plan_count) }
    let(:plan) { job.plans[1] }

    it "removes plan from list" do
      plan.destroy

      expect(job.plans.count).to eq(plan_count - 1)
      job.plans.each_with_index do |plan, i|
        expect(plan.order_num).to eq(i)
      end
    end
  end

  describe "#tab=" do
    it "downcases assignment value" do
      plan.tab = "AdDenDumS"
      expect(plan.tab).to eq("addendums")
    end

    it "assigns nil" do
      plan.tab = nil
      expect(plan.tab).to be_nil
    end
  end

  describe "#csi=" do
    it "assigns nil when blank value" do
      plan.csi = nil
      expect(plan.csi).to be_nil

      plan.csi = ""
      expect(plan.csi).to be_nil

      plan.csi = 0
      expect(plan.csi).to be_nil
    end

    it "assigns csi" do
      plan.csi = "121212"
      expect(plan.csi).to eq("121212")
    end
  end

  describe "#move_to_position" do
    let(:plan_count) { 5 }
    let(:dest_pos) { 4 }
    let(:job) { create(:job, plan_count: plan_count) }
    let(:plan) { job.plans[1] }

    it "doesn't move new plan" do
      expect(build(:plan).move_to_position(3)).to be(false)
    end

    it "moves plan and keeps sequential order" do
      expect(plan.move_to_position(dest_pos)).to be(true)
      job.plans.reload
      plan.reload

      expect(plan.order_num).to eq(dest_pos - 1)
      job.plans.each_with_index do |plan, i|
        expect(plan.order_num).to eq(i)
      end
    end

    it "moves negative position to first" do
      expect(plan.move_to_position(-1)).to be(true)
      plan.reload
      expect(plan.order_num).to eq(0)
    end

    it "moves position out of bounds to last" do
      expect(plan.move_to_position(1000)).to be(true)
      plan.reload
      expect(plan.order_num).to eq(plan_count - 1)
    end
  end
end
