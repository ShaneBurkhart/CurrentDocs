FactoryBot.define do
  factory :plan_document do
    is_current true
    plan { create(:plan_without_documents) }

    transient do
      has_document true
    end

    trait :no_documents do
      has_document false
    end

    factory :plan_document_without_document, traits: [:no_documents]

    after(:create) do |plan_document, evaluator|
      has_document = evaluator.has_document

      if has_document
        create(:document, document_association: plan_document)
      end
    end
  end
end
