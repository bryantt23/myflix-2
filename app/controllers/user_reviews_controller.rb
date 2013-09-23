class UserReviewsController < ApplicationController
  before_filter :require_user
  def create
    @video = Video.find(params[:video_id])
    @user_review = @video.user_reviews.build(params[:user_review].merge!(user: current_user))

    if @user_review.save
      flash[:success] = "Your review has been posted!"
      redirect_to @video
    else
      flash[:error] = "Your post was not created."
      @user_reviews = @video.user_reviews.reload
      render "videos/show"
    end
  end
end