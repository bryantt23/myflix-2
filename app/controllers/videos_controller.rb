class VideosController < ApplicationController
 before_filter  :require_user

 def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @user_reviews = Video.find(params[:id]).user_reviews
  end

  def search
    @searched_videos = Video.search_by_title(params[:search])
  end
end