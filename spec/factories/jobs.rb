require 'faker'

FactoryBot.define do
  factory :job do
    user
    name { Faker::Address.street_address }

    transient do
      plan_count 2
      addendum_count 2
    end

    trait :no_plans do
      plan_count 0
      addendum_count 0
    end

    factory :job_without_plans, traits: [:no_plans]

    factory :archived_job do
      archived true
    end

    after(:create) do |job, evaluator|
      plan_count = evaluator.plan_count
      addendum_count = evaluator.addendum_count

      if plan_count > 0
        create_list(:plan, plan_count, tab: 'plans', job: job)
      end

      if addendum_count > 0
        create_list(:plan, addendum_count, tab: 'addendums', job: job)
      end
    end
  end
end
