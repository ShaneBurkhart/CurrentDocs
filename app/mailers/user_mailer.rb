class UserMailer < ActionMailer::Base
  default from: "shaneburkhart@gmail.com"

  def share_notification(user, share, is_guest)
  	@share = share
  	@user = user
  	@is_guest = is_guest
  	@name = @share.job.user.name
  	@subject = "Plan Source - #{@name} has shared a job with you!"
  	mail(to: @guest, subject: @subject)
  end
end
