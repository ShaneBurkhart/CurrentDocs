FactoryBot.define do
  factory :permissions, class: 'Permissions' do
    authenticatable { create(:share_link) }
    job_permissions { create(:job_permission) }

    factory :blank_permissions do
      job_permissions { [] }
    end
  end
end
