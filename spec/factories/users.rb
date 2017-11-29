FactoryBot.define do
  factory :user do
    first_name "Shane"
    last_name "Burkhart"
    sequence(:email) { |n| "shane+#{n}@currentdocs.com" }
    password "password"
    password_confirmation "password"

    transient do
      job_count 1
      archived_job_count 1
      share_link_count 1
    end

    trait :no_jobs do
      job_count 0
      archived_job_count 0
    end

    trait :with_share_links do
      share_link_count 3
    end

    factory :user_without_jobs, traits: [:no_jobs]
    factory :user_with_share_links, traits: [:with_share_links]

    after(:create) do |user, evaluator|
      job_count = evaluator.job_count
      archived_job_count = evaluator.archived_job_count
      share_link_count = evaluator.share_link_count

      if job_count > 0
        create_list(:job, job_count, user: user)
      end

      if archived_job_count > 0
        create_list(:archived_job, archived_job_count, user: user)
      end

      if share_link_count > 0
        create_list(:share_link, share_link_count, user: user)
      end
    end
  end
end
