class ApplicationController < ActionController::Base
    protect_from_forgery

    rescue_from ActiveRecord::RecordNotFound do |exception|
      redirect_to jobs_path, :alert => exception.message
    end

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to jobs_path, :alert => exception.message
    end

    def authenticate_user!
      # We don't need to authenticate user if current_share_link exists
      # and the user isn't logged in.
      return if current_share_link and !devise_current_user

      # Calling super with no arguments passes them through
      super
    end

    def devise_current_user
      @devise_current_user ||= warden.authenticate(:scope => :user)
    end

    def current_share_link
      @current_share_link ||= ShareLink.where(token: session[:share_link_token]).first
    end

    def current_user
      devise_current_user || current_share_link
    end

    def render_modal(template)
      render template, formats: [:html], layout: false
    end

    ###### OLD BUT NOT IRRELEVENT ######

    def not_authorized
      render json: { error: "You don't have permission to do that." }, status: 403
    end

    def user
      current_user || User.find_by_authentication_token(params[:token])
    end

    def not_found
	     raise ActionController::RoutingError.new('Not Found')
    end

    def go_to_app?
      redirect_to jobs_path if current_user
    end

    def after_sign_in_path_for(resource_or_scope)
      session[:user_return_to] || jobs_path
    end

    def user_not_there!
	     render text: "No user signed in" unless user_signed_in? || User.find_by_authentication_token(params[:token]) || params[:share_token]
    end

    def error(message)
      render json: { error: message }
    end

    def render_no_permission
      # This used to send test "You don't have permission" but empty braces
      # mean error in most cases. Sorry...
	    render json: {}
    end

    def check_admin!
      if !user.admin?
        not_found
      end
    end
end
