require 'colorize'
class NotificationMailer < ActionMailer::Base
  default from: "from@example.com"
  helper :verbage_helper

  def test_email(user)
    @user = user
    @url = 'localhost:3000'
    mail(to: User.first.email, subject: 'Test email')
  end

  def notification_email(event, job, sub)
    @plan = event.get_event # Plan
    @job = @plan.job
    @event = event
    @event_user = event.user
    @receip = sub.user
    @sub = sub

    mail(to: User.first.email, subject: "[PlanSource] Notification #{@event.target_type.capitalize} #{@event.target_action.capitalize}")
  end


end
