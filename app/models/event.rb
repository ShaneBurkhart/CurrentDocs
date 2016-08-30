# Event.create(target_type:'job', target_id:1, target_action:'updated', user_id:1)
class Event < ActiveRecord::Base
  attr_accessible :target_action, :target_id, :target_type, :user_id

  belongs_to :user

  after_commit :notify_subscribers, :on => :create

  # Send logic to update users to NotificationSubscription
  def notify_subscribers
    NotificationSubscription.notify(self)
  end

end
