class ShareLinksController < ApplicationController
  before_filter :authenticate_user!, except: [:login]

  def login
    @share_link = ShareLink.where(token: params[:token]).first

    if !@share_link
      return redirect_to new_user_session_path
    end

    session[:share_link_token] = @share_link.token

    redirect_to jobs_path
  end
end
