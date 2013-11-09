class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from:    'info@myflix.com',
         to:      user.email,
         subject: "Welcome to Myflix!"
  end

  def send_forgot_password(user)
    @user = user
    mail from:    'info@myflix.com',
         to:      user.email,
         subject: 'Forgot Password Confirmation'
  end

  def send_invite(invite_id)
    invite = Invite.find(invite_id)
    @invite = invite
    mail from:    'info@myflix.com',
         to:      invite.invited_email,
         subject: "#{invite.inviter.full_name} wants you to Join MyFlix."
  end

  def send_locked_account_notice(user)
    @user = user
    mail from:    'info@myflix.com',
         to:      user.email,
         subject: "You have been locked out of MyFlix, #{user.full_name}"
  end
end