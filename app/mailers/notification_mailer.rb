class NotificationMailer < ActionMailer::Base
  include SendGrid
  default from: "PlanSource <plansource-noreply@plansource.io>"
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

    mail(to: @receip.email, subject: "[PlanSource] Notification #{@event.target_type.capitalize} #{@event.target_action.capitalize}")
  end


end
