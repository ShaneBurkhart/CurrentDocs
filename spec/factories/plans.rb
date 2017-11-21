FactoryBot.define do
  factory :plan do
    job
    name { Faker::Address.street_address }
    tab { Plan::TABS.sample }

    transient do
      has_current_doc true
      document_history_count 2
    end

    trait :no_documents do
      has_current_doc false
      document_history_count 0
    end

    factory :plan_without_documents, traits: [:no_documents]

    after(:create) do |plan, evaluator|
      has_current_doc = evaluator.has_current_doc
      document_history_count = evaluator.document_history_count

      # If we have document histories, then we need a current doc
      if has_current_doc or document_history_count > 0
        create(:plan_document, plan: plan)
      end

      if document_history_count > 0
        create_list(:plan_document_history, document_history_count, plan: plan)
      end
    end
  end
end
