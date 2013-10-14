class Admin::VideosController < ApplicationController
  before_filter :require_user, :require_admin

  def new
      @video = Video.new
  end

  def create
    @video = Video.create(params[:video])
  end

  private

  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to root_path
    end
  end
end