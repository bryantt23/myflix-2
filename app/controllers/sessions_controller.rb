class SessionsController < ApplicationController
  def new
    redirect_to videos_path if current_user
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password]) && !user.locked
      session[:user_id] = user.id
      redirect_to current_user.admin ? new_admin_video_path :
                  videos_path, notice: 'You are signed in, enjoy!'
    else
      if user.locked
        flash[:error] = "Your account has been locked. Invalid card."
      else
        flash[:error] = "Sorry, something's wrong with your email or password."
      end
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'You are signed out.'
  end
end