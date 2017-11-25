FactoryBot.define do
  factory :plan_tab_permission do
    tab { Plan::TABS.sample }
    job_permission { create(:job_permission) }
  end
end
