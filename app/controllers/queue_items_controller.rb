class QueueItemsController < ApplicationController

  def show
    @queue_items = QueueItem.where("user_id == #{session[:user_id]}").order("order_id")
  end

  def create
    @queue_items = QueueItem.where("user_id == #{session[:user_id]}").order("order_id")
    @queued_video = QueueItem.new(user_id: session[:user_id], video_id: params[:video_id])

    @queue_items.each do |queue_item|
      if queue_item.video.id == @queued_video.video.id
        flash[:error] = "That video is already in your queue."
        redirect_to video_path(params[:video_id])
        return
      end
    end

    if @queued_video.save
      flash[:notice] = "You've added #{@queued_video.video.title} movie to your queue."
      redirect_to queue_item_path(session[:user_id])
    else
      flash[:error] = "Something went wrong."
      render :show
    end
  end

  def update
  end

  def destroy
    QueueItem.delete(params[:id])
    flash[:notice] = "You have removed a movie from your queue."
    redirect_to queue_item_path(session[:user_id])
  end
end