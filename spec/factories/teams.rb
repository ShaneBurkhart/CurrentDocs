FactoryBot.define do
  factory :team do
    name { Faker::Company.name }

    transient do
      job_count 0
    end

    trait :with_jobs do
      job_count 2
    end

    after(:create) do |team, evaluator|
      job_count = evaluator.job_count

      if job_count > 0
        create_list(:job, job_count, team: team)
      end
    end
  end
end
