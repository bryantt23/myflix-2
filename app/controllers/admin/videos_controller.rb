class Admin::VideosController < ApplicationController
  before_filter :require_user, :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(title:       params[:video][:title],
                       description: params[:video][:description],
                       large_cover: params[:video][:large_cover],
                       small_cover: params[:video][:small_cover],
                       video_url:   params[:video][:video_url])
    if @video.save
      VideosCategory.create(category_id: params[:video][:categories],
                            video_id: @video.id)
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
   @video = Video.find(pararms[:video_id])
   @video.update_attributes(params[:video])
   if @video.save
     flash[:success] = "You have updated #{@video.title}"
     redirect_to videos_path
   else
     flash[:error] = "You were unable to update #{@video.title}"
     render :edit
   end
  end

  private

  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to root_path
    end
  end
end
