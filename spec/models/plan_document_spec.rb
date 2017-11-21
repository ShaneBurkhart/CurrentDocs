require 'rails_helper'

RSpec.describe PlanDocument, :type => :model do
  let(:plan_document) { create(:plan_document) }

  it { expect(subject).to belong_to(:plan) }
  it { expect(subject).to have_one(:document) }

  describe "validations" do
    subject { plan_document }

    it { expect(subject).to validate_presence_of(:plan_id) }

    it "should not allow multiple current plan documents for plan" do
      plan_doc = create(:plan_document)
      current_doc = build(
        :plan_document,
        plan_id: plan_doc.plan_id,
        is_current: true
      )

      expect(current_doc).not_to be_valid
    end
  end
end
