class UserMailer < ActionMailer::Base
  include SendGrid
  default from: "plansource-noreply@plansource.io"

  def share_notification(user, share, is_guest, pass)
  	@share = share
  	@user = user
    @pass = pass
  	@is_guest = is_guest
  	@name = @share.job.user.full_name
  	@accept_url = "http://plansource.heroku.com/api/shares/#{@share.id}?token=#{@share.token}"
  	@subject = "Plan Source - #{@name} has shared a job with you!"
  	mail(to: @share.user.email, subject: @subject)
  end
end