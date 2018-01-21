# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

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
