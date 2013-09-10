class UserReviewsController < ApplicationController
  def create
    @user_review = UserReview.new(params[:user_review])

    if @user_review.save
      flash[:notice] = "Your review has been posted."
      redirect_to video_path
    else
      render :show
    end
  end
end