require 'rails_helper'

RSpec.describe Plan, :type => :model do
  it { expect(subject).to belong_to(:job) }
  it { expect(subject).to have_one(:plan_document) }
  it { expect(subject).to have_one(:document) }
  it { expect(subject).to have_many(:plan_document_histories) }
  it { expect(subject).to have_many(:document_histories) }

  describe "validations" do
    subject { create(:plan) }
    it { expect(subject).to validate_presence_of(:job_id) }
    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:tab) }
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
end
