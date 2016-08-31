require 'colorize'
class NotificationMailer < ActionMailer::Base
  default from: "from@example.com"
  helper :verbage_helper

  def test_email(user)
    @user = user
    @url = 'localhost:3000'
    mail(to: User.first.email, subject: 'Test email')
  end

  def notification_email(event, receip)
    @event_object = event.get_event
    @event = event
    @event_user = event.user
    @receip = receip
    mail(to: User.first.email, subject: "[PlanSource] Notification #{@event.target_type.capitalize} #{@event.target_action.capitalize}")
  end


end
