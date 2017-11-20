class ApplicationController < ActionController::Base
    protect_from_forgery

    before_filter :last_seen

    rescue_from ActiveRecord::RecordNotFound, :with => :not_authorized

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to jobs_path, :alert => exception.message
    end

    def devise_current_user
      @devise_current_user ||= warden.authenticate(:scope => :user)
    end

    # TODO add login for tokens and shared users, links, etc.
    def current_user
      devise_current_user
    end

    def not_authorized
      render json: { error: "You don't have permission to do that." }, status: 403
    end

    ###### OLD BUT NOT IRRELEVENT ######

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
	session[:user_return_to] || app_path
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

    private
      def last_seen
        if user_signed_in?
          user.last_seen = Time.now
          user.save
        end
      end
end
