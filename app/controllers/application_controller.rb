class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_user
    redirect_to login_path unless current_user
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to root_path
    end
  end

  helper_method :current_user

end
