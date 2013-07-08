class UserMailer < ActionMailer::Base
  default from: "shaneburkhart@gmail.com"

  def share_notification(user, share, is_guest)
  	@share = share
  	@user = user
  	@is_guest = is_guest
  	@name = @share.job.user.name
  	@accept_url = "http://plansource.heroku.com/api/shares/#{@share.id}?token=#{@share.token}"
  	@subject = "Plan Source - #{@name} has shared a job with you!"
  	mail(to: @share.user.email, subject: @subject)
  end
end