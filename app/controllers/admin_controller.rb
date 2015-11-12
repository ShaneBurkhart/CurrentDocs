class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_admin!

  def sub_logins
    @share_links = ShareLink.order("updated_at DESC").all
  end

  private
    def check_admin!
      if !user.admin?
        not_found
      end
    end
end
