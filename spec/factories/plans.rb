# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  tab        :string(255)      not null
#  job_id     :integer          not null
#  order_num  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_plans_on_job_id     (job_id)
#  index_plans_on_order_num  (order_num)
#  index_plans_on_tab        (tab)
#

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
