require 'rails_helper'

RSpec.describe PlanDocumentHistory, :type => :model do
  it { should belong_to(:plan) }
  it { should belong_to(:document) }

  describe "validations" do
    subject { create(:plan_document_history) }
    it { should validate_presence_of(:plan_id) }
    it { should validate_presence_of(:document_id) }
    it { should validate_uniqueness_of(:document_id) }

    it "should not allow document that is current doc" do
      current_doc = create(:plan_document)
      doc_history = PlanDocumentHistory.new(
        plan_id: current_doc.plan_id,
        document_id: current_doc.document_id
      )

      doc_history.should_not be_valid
    end
  end
end
