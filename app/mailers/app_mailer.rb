class AppMailer < ActionMailer::Base
  def notify_on_new_user(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Welcome to Myflix!"
  end
end