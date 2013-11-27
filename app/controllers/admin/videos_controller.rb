class Admin::VideosController < ApplicationController
  before_filter :require_user, :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have added #{@video.title}"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Unable to add #{@video.title}. Please check the errors."
      render :new
    end
  end

  def edit
    @video = Video.find(params[:id])
  end

  def update
   @video = Video.find(params[:id])
   @video.update_attributes(video_params)
   if @video.save
     flash[:success] = "You have updated #{@video.title}"
     redirect_to video_path(@video)
   else
     flash[:error] = "You were unable to update #{@video.title}"
     render :edit
   end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :large_cover, :small_cover, :video_url, category_ids: [])
  end

  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to root_path
    end
  end
end
