require 'faker'

FactoryBot.define do
  factory :job do
    team { create(:team) }
    user { create(:user) }
    name { Faker::Address.street_address }
    is_archived false

    transient do
      plan_count 0
      addendum_count 0
    end

    trait :with_all_plans do
      plan_count 2
      addendum_count 2
    end

    trait :with_plans do
      plan_count 2
    end

    trait :with_addendums do
      addendum_count 2
    end

    trait :as_archived do
      is_archived true
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
