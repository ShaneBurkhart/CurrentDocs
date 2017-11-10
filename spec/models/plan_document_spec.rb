require 'rails_helper'

RSpec.describe PlanDocument, :type => :model do
  it { should belong_to(:plan) }
  it { should belong_to(:document) }

  describe "validations" do
    subject { create(:plan_document) }
    it { should validate_presence_of(:plan_id) }
    it { should validate_uniqueness_of(:plan_id) }
    it { should validate_presence_of(:document_id) }
    it { should validate_uniqueness_of(:document_id) }

    it "should not allow document that is in doc histories" do
      doc_history = create(:plan_document_history)
      current_doc = PlanDocument.new(
        plan_id: doc_history.plan_id,
        document_id: doc_history.document_id
      )

      current_doc.should_not be_valid
    end
  end
end
