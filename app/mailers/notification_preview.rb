class NotificationPreview < ActionMailer::Base
  def self.update
    event = Event.first
    email_receip = User.first
    # subscription = NotificationSubscription.first
    NotificationMailer.notification_email(event, email_receip).deliver
  end
end
