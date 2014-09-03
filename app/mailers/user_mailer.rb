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

  def arbitrary_message(from, user, message)
    @message = message
    @user = user
    @to = user.email
    @from = from
    @subject = "You have a message from #{@from}."
    @body = [
      "You have a new message from #{@from}:",
      "\n\n",
      @message
    ].join ""

    mail(to: @to, subject: @subject, body: @body, content_type: "text/plain")
  end

end
