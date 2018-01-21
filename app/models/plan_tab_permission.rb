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

class PlanTabPermission < ActiveRecord::Base
  attr_accessible :can_create, :can_update, :can_destroy

  belongs_to :job_permission

  validates :tab, :job_permission_id, presence: true
  validates :can_create, :can_update, :can_destroy, inclusion: { in: [ true, false ] }

  validate :check_for_valid_tab_name

  def tab=(tab)
    tab = tab.to_s if tab.is_a? Symbol
    self[:tab] = tab.nil? ? tab : tab.downcase
  end

  def update_permissions(permissions)
    permissions = permissions || []

    self.can_create = permissions.include?(:can_create)
    self.can_update = permissions.include?(:can_update)
    self.can_destroy = permissions.include?(:can_destroy)

    return self.save
  end

  private

    def check_for_valid_tab_name
      if !Plan::TABS.include?(self.tab)
        errors.add(:tab, "isn't a valid tab")
      end
    end
end
