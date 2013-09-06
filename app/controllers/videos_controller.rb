class VideosController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:video_id])
  end

  def search
    @searched_videos = Video.search_by_title(params[:search])
  end
end