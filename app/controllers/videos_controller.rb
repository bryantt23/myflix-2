class VideosController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:video_id])
  end
end