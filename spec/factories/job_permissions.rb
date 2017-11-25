FactoryBot.define do
  factory :job_permission do
    job { create(:job_without_plans) }
    permissions { create(:blank_permissions) }
  end
end
