class NotificationSubscription < ActiveRecord::Base
  attr_accessible :is_active, :object_action, :object_type, :user_id

  belongs_to :user

  # Be aware of a user requesting no email notifications
  # Be aware of manager refusing notifications to a user
  def notify(event)

  end
end
