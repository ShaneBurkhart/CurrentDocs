class JobPermissionsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @job_permission = JobPermission.find(params[:id])
    @share_link = @job_permission.permissions.authenticatable
    @tab_permissions = tab_permissions(@job_permission)

    authorize! :update, @job_permission

    render :edit
  end

  def update
    @job_permission = JobPermission.find(params[:id])
    @share_link = @job_permission.permissions.authenticatable

    authorize! :update, @job_permission

    if !@job_permission.update_permissions(build_job_permissions_hash)
      @tab_permissions = tab_permissions(@job_permission)
      return render :edit
    end

    redirect_to share_link_path(@share_link)
  end

  private

    def build_job_permissions_hash
      job_permission_param = params["job_permission"] || {}
      job_permissions = []

      job_permission_param.each do |key, val|
        job_permissions.push(key.to_sym) if val == "1"
      end

      tab_permissions = params["tab_permissions"] || {}

      tab_permissions.each do |tab, permissions|
        tab_permissions[tab] = []

        permissions.each do |key, val|
          tab_permissions[tab].push(key.to_sym) if val == "1"
        end

        if tab_permissions[tab].empty?
          # No permissions were set for this tab.
          tab_permissions.delete(tab)
        else
          # We remove can_read from permissions since the presence of the tab
          # permissions array signifies they can read. Even when empty.
          # Check the spec for job permissions to see how #update_permissions works.
          tab_permissions[tab].delete(:can_read)
        end
      end

      return {
        permissions: job_permissions,
        tabs: tab_permissions
      }
    end

    def tab_permissions(job_permission)
      tab_permissions = []

      # Adding the tab permissions in order
      Plan::TABS.each do |tab|
        # Pass false so it returns new records for tab permission.
        tab_permissions.push(
          job_permission.find_or_create_tab_permission(tab, false)
        )
      end

      return tab_permissions
    end
end
