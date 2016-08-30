class NotificationSubscription < ActiveRecord::Base
  attr_accessible :is_active, :target_action, :target_id, :target_type, :user_id

  belongs_to :user

  # Be aware of a user requesting no email notifications
  # Be aware of manager refusing notifications to a user
  def self.notify(event)
    puts "Sending notification email! event_id:#{event.id}"
    user = User.find(1)
    NotificationMailer.test_email(user).deliver
  end
end
