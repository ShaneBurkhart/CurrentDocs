# == Schema Information
#
# Table name: plan_tab_permissions
#
#  id                :integer          not null, primary key
#  tab               :string(255)      not null
#  job_permission_id :integer          not null
#  can_create        :boolean          default(FALSE)
#  can_update        :boolean          default(FALSE)
#  can_destroy       :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_plan_tab_permissions_on_job_permission_id  (job_permission_id)
#

FactoryBot.define do
  factory :plan_tab_permission do
    tab { Plan::TABS.sample }
    job_permission { create(:job_permission) }
  end
end
