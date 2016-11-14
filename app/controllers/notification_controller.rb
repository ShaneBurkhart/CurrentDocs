# I regret calling this model notification subscription. It was because something
# with strip was named subscription and I didnt want to mess with anything remotely
# money related


class NotificationController < ApplicationController
  def unsubscribe
    if result = NotificationSubscription.where(token: params[:id]).first
      if result.is_active
        result.update_attributes(is_active:false)
        render :json => "You are unsubscribed from updates from this #{result.target_type}"
      else
        render :json => "You are already unsubscribed from these #{result.target_type} updates."
      end
    else
      render :json => "The token seems to be invalid. We want to make sure the wrong people aren't trying to unsubscribe you from updates."
    end
  end
end
