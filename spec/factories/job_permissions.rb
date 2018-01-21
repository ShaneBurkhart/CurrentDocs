# == Schema Information
#
# Table name: job_permissions
#
#  id             :integer          not null, primary key
#  job_id         :integer          not null
#  permissions_id :integer          not null
#  can_update     :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_job_permissions_on_job_id          (job_id)
#  index_job_permissions_on_permissions_id  (permissions_id)
#

FactoryBot.define do
  factory :job_permission do
    job { create(:job) }
    permissions { create(:permissions) }

    trait :with_archived_job do
      job { create(:job, :as_archived) }
    end
  end
end
