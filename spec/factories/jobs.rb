# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  is_archived :boolean          default(FALSE)
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_jobs_on_is_archived  (is_archived)
#  index_jobs_on_user_id      (user_id)
#

require 'faker'

FactoryBot.define do
  factory :job do
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
