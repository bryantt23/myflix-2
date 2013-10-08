class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Welcome to Myflix!"
  end

  def send_forgot_password(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: 'Forgot Password Confirmation'
  end

  def send_invite(invite)
    @invite = invite
    mail from: 'info@myflix.com', to: invite.invited_email, subject: "#{invite.inviter.full_name} wants you to Join MyFlix."
  end
end