FactoryBot.define do
  factory :job_permission do
    job { create(:job) }
    permissions { create(:permissions) }

    trait :with_archived_job do
      job { create(:job, :as_archived) }
    end
  end
end
