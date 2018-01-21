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

class JobPermission < ActiveRecord::Base
  attr_accessible :job_id, :permissions_id, :can_update

  belongs_to :job
  belongs_to :permissions
  has_many :plan_tab_permissions

  validates :job_id, :permissions_id, presence: true
  validates :can_update, inclusion: { in: [ true, false ] }

  # Set save to false if you want a new instance  instead of create.
  # Useful for rendering job permissions for tabs that aren't shared.
  def find_or_create_tab_permission(tab, should_save = true)
    return nil if tab.nil?

    tab_permission_class = nil

    if Plan::TABS.include?(tab)
      tab_permission_class = PlanTabPermission
    else
      # If not a valid tab name, then return nil
      return nil
    end

    tab_permission = tab_permission_class.where(
      tab: tab, job_permission_id: self.id
    ).first

    if tab_permission.nil?
      tab_permission = tab_permission_class.new
      tab_permission.tab = tab
      tab_permission.job_permission_id = self.id

      tab_permission.save if should_save
    end

    return tab_permission
  end

  # See spec for permissions_hash structure
  def update_permissions(permissions_hash)
    permissions_hash = permissions_hash || {}
    permissions_hash_for_tabs = permissions_hash[:tabs] || {}
    permissions = permissions_hash[:permissions] || []

    # Make sure keys are strings for tabs
    permissions_hash_for_tabs = permissions_hash_for_tabs.stringify_keys

    self.can_update = permissions.include?(:can_update)

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
        plan_tab_permission = PlanTabPermission.new
        plan_tab_permission.tab = tab
        plan_tab_permission.job_permission_id = self.id
        plan_tab_permission.save
      end

      success = success && plan_tab_permission.update_permissions(permissions)
    end

    self.reload

    return success
  end
end
