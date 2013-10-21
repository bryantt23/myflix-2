class UsersController < ApplicationController
  before_filter :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    charge_sign_up_fee

    if @user.save && flash[:error].empty?
      handle_invitation
      AppMailer.send_welcome_email(@user).deliver
      redirect_to login_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invite_token
    invite = Invite.where(token: params[:token]).first

    if invite
      @user = User.new(email: invite.invited_email)
      @invite_token = invite.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def charge_sign_up_fee

    charge = StripeWrapper::Charge.create(
      :amount => 999,
      :card => params[:stripeToken],
      :description => "Charge for #{@user.full_name}: #{@user.email}"
    )
    if charge.successful?
      return
    else
      flash[:error] = charge.error_message
    end
  end

  def handle_invitation
    if params[:invite_token].present?
      invite = Invite.where(token: params[:invite_token]).first
      @user.follow(invite.inviter)
      invite.inviter.follow(@user)
      invite.update_column(:token, nil)
    end
  end
end