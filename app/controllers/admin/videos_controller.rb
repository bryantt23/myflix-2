class Admin::VideosController < ApplicationController
  before_filter :require_user, :require_admin

  def new
      @video = Video.new
  end

  def create
    @video = Video.new(title: params[:video][:title],
                       description: params[:video][:description])
    if @video.save
      params[:video][:categories].each do |category_id|
        if category_id != ""
          VideosCategory.create(category_id: category_id, video_id: @video.id)
        end
      end
      flash[:success] = "You have added #{@video.title}"
      render :new
    else
      flash[:error] = "Unable to add #{@video.title}. Please check the errors."
      render :new
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