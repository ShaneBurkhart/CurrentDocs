FactoryBot.define do
  factory :plan_document_history do
    document { create(:document) }
    plan { create(:plan) }
  end
end
