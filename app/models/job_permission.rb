class JobPermission < ActiveRecord::Base
  attr_accessible :job_id, :permissions_id, :can_edit

  belongs_to :job
  belongs_to :permissions
  has_many :plan_tab_permissions

  validates :job_id, :permissions_id, presence: true
  validates :can_edit, inclusion: { in: [ true, false ] }

  # See spec for permissions_hash structure
  def update_permissions(permissions_hash)
    permissions_hash = permissions_hash || {}
    permissions_hash_for_tabs = permissions_hash[:tabs] || {}
    permissions = permissions_hash[:permissions] || []

    # Make sure keys are strings for tabs
    permissions_hash_for_tabs = permissions_hash_for_tabs.stringify_keys

    self.can_edit = permissions.include?(:edit)

    success = self.save

    return false if !success

    self.plan_tab_permissions.each do |plan_tab_permission|
      # Remove the plan tab permission if tab is nil in hash
      if permissions_hash_for_tabs[plan_tab_permission.tab].nil?
        plan_tab_permission.destroy
      end
    end

    permissions_hash_for_tabs.each do |tab, permissions|
      plan_tab_permission = PlanTabPermission.where(
        tab: tab, job_permission_id: self.id
      ).first

      if plan_tab_permission.nil?
        plan_tab_permission = PlanTabPermission.create(
          tab: tab, job_permission_id: self.id
        )
      end

      success = success && plan_tab_permission.update_permissions(permissions)
    end

    self.reload

    return success
  end
end
