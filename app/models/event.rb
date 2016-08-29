class Event < ActiveRecord::Base
  attr_accessible :object_action, :object_id, :object_type, :user_id

  belongs_to :user

  after_commit :notify_subscribers, :on=> :create

  # Send logic to update users to NotificationSubscription
  def notify_subscribers
    NotificationSubscription.notify(self)
  end

end
