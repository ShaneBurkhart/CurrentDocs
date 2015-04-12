class UserMailer < ActionMailer::Base
    include SendGrid
    default from: "PlanSource <plansource-noreply@plansource.io>"

    def share_notification(share)
	@share = share
	@email = share.sharer.email
	@subject = "Plan Source - #{@email} has shared a job with you!"
	mail(to: @share.user.email, subject: @subject)
    end

    def guest_user_notification(user, inviter_email)
	@user = user
	puts @user.email
	@signup_link = @user.signup_link
	@inviter_email = inviter_email
	@subject = "Plan Source - #{@inviter_email} has added you as a contact!"
	mail(to: @user.email, subject: @subject)
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
