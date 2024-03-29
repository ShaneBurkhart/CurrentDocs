FactoryBot.define do
  factory :permissions, class: 'Permissions' do
    authenticatable { create(:share_link) }

    transient do
      job_permission_count 0
    end

    trait :with_job_permissions do
      job_permission_count 2
    end


    after(:create) do |permissions, evaluator|
      job_permission_count = evaluator.job_permission_count

      if job_permission_count > 0
        create_list(:job_permission, job_permission_count, permissions: permissions)
      end
    end
  end
end
