require 'rails_helper'

RSpec.describe PlanDocument, :type => :model do
  let(:plan_document) { @plan_document }

  before(:all) { @plan_document = create(:plan_document) }

  it { expect(subject).to belong_to(:plan) }
  it { expect(subject).to have_one(:document) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:plan_id) }

    it "should not allow multiple current plan documents for plan" do
      current_doc = build(:plan_document, plan: plan_document.plan)

      expect(current_doc).not_to be_valid
    end
  end
end
