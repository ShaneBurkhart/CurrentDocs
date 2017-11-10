FactoryBot.define do
  factory :plan_document do
    document { create(:document) }
    plan { create(:plan_without_documents) }
  end
end

# Plan
# PlanDocument
# - plan_id (unique key)
# - document_id (update when uploading)
# PlanDocumentHistory
# - plan_id
# - document_id
# Document
