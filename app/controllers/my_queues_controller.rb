class MyQueuesController < ApplicationController

  def show
    @queue = MyQueue.where("user_id == #{session[:user_id]}").order("order_id")
  end

  def create
    @queued_video = MyQueue.new(user_id: session[:user_id], video_id: params[:video_id])

    if @queued_video.save
      flash[:notice] = "You've added #{@queued_video.video.title} movie to your queue."
      redirect_to my_queue_path(session[:user_id])
    else
      flash[:error] = "Something went wrong."
      render :show
    end
  end

  def update

  end
end