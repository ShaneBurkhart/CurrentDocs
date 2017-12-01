FactoryBot.define do
  factory :plan do
    job { create(:job) }
    name { Faker::Address.street_address }
    tab { Plan::TABS.sample }

    transient do
      has_current_doc false
      document_history_count 0
    end

    trait :as_plan do
      tab "plans"
    end

    trait :as_addendum do
      tab "addendums"
    end

    trait :with_current_doc do
      has_current_doc true
    end

    trait :with_document_histories do
      document_history_count 2
    end

    after(:create) do |plan, evaluator|
      has_current_doc = evaluator.has_current_doc
      document_history_count = evaluator.document_history_count

      # If we have document histories, then we need a current doc
      if has_current_doc or document_history_count > 0
        create(:plan_document, :with_document, plan: plan)
      end

      if document_history_count > 0
        create_list(:plan_document, document_history_count, :as_history,
                    :with_document, plan: plan)
      end
    end
  end
end
