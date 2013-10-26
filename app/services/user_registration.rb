class UserRegistration

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def register(stripe_token, invite_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(
        :card => stripe_token,
        :user => @user)
      if customer.successful?
        @user.save
        handle_invitation(invite_token)
        AppMailer.send_welcome_email(@user).deliver
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information. Check the errors below."
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invite_token)
    if invite_token.present?
      invite = Invite.where(token: invite_token).first
      @user.follow(invite.inviter)
      invite.inviter.follow(@user)
      invite.update_column(:token, nil)
    end
  end
end