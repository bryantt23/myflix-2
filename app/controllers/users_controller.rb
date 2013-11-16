class UsersController < ApplicationController
  before_filter :require_user, only: [:show,
                                      :update,
                                      :edit,
                                      :plan_and_billing]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    result = UserRegistration.new(@user).
              register(params[:stripeToken],params[:invite_token])
    if result.successful?
      flash[:success] = "Thank you for registering with MyFlix. Please sign in now."
      redirect_to login_path
    else
      flash[:error] = result.error_message
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "You have updated your account."
      redirect_to videos_path
    else
      flash[:error] = "Unable to update account."
      render :edit
    end
  end

  def plan_and_billing
    @payments = Payment.get_user_payments(current_user.id)
  end

  def cancel_service
    StripeWrapper::Customer.cancel_service(current_user.customer_token)
    flash[:error] = "Your service has been canceled. Your account will be locked at the end of this billing cycle."
    redirect_to plan_and_billing_user_path(current_user)
  end
end