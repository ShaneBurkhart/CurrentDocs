# == Schema Information
#
# Table name: share_links
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  token      :string(255)      not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_share_links_on_token    (token) UNIQUE
#  index_share_links_on_user_id  (user_id)
#

FactoryBot.define do
  factory :share_link do
    name { Faker::Name.name }
    user { create(:user) }

    transient do
      job_permission_count 0
      archived_job_permission_count 0
    end

    trait :with_job_permissions do
      job_permission_count 2
      archived_job_permission_count 2
    end

    trait :with_open_job_permissions do
      job_permission_count 2
    end

    trait :with_archived_job_permissions do
      archived_job_permission_count 2
    end

    after(:create) do |share_link, evaluator|
      job_permission_count = evaluator.job_permission_count
      archived_job_permission_count = evaluator.archived_job_permission_count

      if job_permission_count > 0
        create_list(
          :job_permission,
          job_permission_count,
          permissions: share_link.permissions
        )
      end

      if archived_job_permission_count > 0
        create_list(
          :job_permission,
          archived_job_permission_count,
          :with_archived_job,
          permissions: share_link.permissions
        )
      end
    end
  end
end
