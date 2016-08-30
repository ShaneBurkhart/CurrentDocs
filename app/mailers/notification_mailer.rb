class NotificationMailer < ActionMailer::Base
  default from: "from@example.com"

  def test_email(user)
    @user = user
    @url = 'localhost:3000'
    mail(to: "dgwetherington@gmail.com", subject: 'Test email')
  end
end
