FactoryBot.define do
  factory :user do
    first_name "Shane"
    last_name "Burkhart"
    sequence(:email) { |n| "shane+#{n}@currentdocs.com" }
    password "password"
    password_confirmation "password"

    transient do
      job_count 0
      archived_job_count 0
      share_link_count 0
    end

    trait :with_jobs do
      job_count 2
      archived_job_count 2
    end

    trait :with_open_jobs do
      job_count 2
    end

    trait :with_archived_jobs do
      archived_job_count 2
    end

    trait :with_share_links do
      share_link_count 3
    end

    after(:create) do |user, evaluator|
      job_count = evaluator.job_count
      archived_job_count = evaluator.archived_job_count
      share_link_count = evaluator.share_link_count

      if job_count > 0
        create_list(:job, job_count, user: user)
      end

      if archived_job_count > 0
        create_list(:job, archived_job_count, :as_archived, user: user)
      end

      if share_link_count > 0
        create_list(:share_link, share_link_count, user: user)
      end
    end
  end
end
