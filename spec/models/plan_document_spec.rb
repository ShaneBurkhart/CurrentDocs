require 'rails_helper'

RSpec.describe PlanDocument, :type => :model do
  it { expect(subject).to belong_to(:plan) }
  it { expect(subject).to belong_to(:document) }

  describe "validations" do
    subject { create(:plan_document) }
    it { expect(subject).to validate_presence_of(:plan_id) }
    it { expect(subject).to validate_uniqueness_of(:plan_id) }
    it { expect(subject).to validate_presence_of(:document_id) }
    it { expect(subject).to validate_uniqueness_of(:document_id) }

    it "should not allow document that is in doc histories" do
      doc_history = create(:plan_document_history)
      current_doc = build(
        :plan_document,
        plan_id: doc_history.plan_id,
        document_id: doc_history.document_id
      )

      expect(current_doc).not_to be_valid
    end
  end
end
