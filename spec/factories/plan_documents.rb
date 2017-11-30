FactoryBot.define do
  factory :plan_document do
    is_current true
    plan { create(:plan) }

    transient do
      has_document false
    end

    trait :as_history do
      is_current false
    end

    trait :with_document do
      has_document true
    end

    after(:create) do |plan_document, evaluator|
      has_document = evaluator.has_document

      if has_document
        create(:document, document_association: plan_document)
      end
    end
  end
end
