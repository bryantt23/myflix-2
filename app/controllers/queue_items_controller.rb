class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    @queue_items = current_user.queue_items

    if @queue_items.size == 0
      @queued_video = QueueItem.new(user_id: current_user.id,
                                    video_id: params[:video_id],
                                    order_id: 1)
    else
      position = @queue_items.last.order_id + 1
      @queued_video = QueueItem.new(user_id: current_user.id,
                                    video_id: params[:video_id],
                                    order_id: position)
    end

    @queue_items.each do |queue_item|
      if queue_item.video_id == @queued_video.video_id
        flash[:error] = "This video is already in your queue."
        redirect_to video_path(params[:video_id])
        return
      end
    end

    if @queued_video.save
      flash[:notice] = "You've added #{@queued_video.video.title} to your queue."
      redirect_to queue_items_path
    else
      flash[:error] = "Something went wrong."
      render :index
    end
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_order_id
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "You must enter a whole number in the List Order column."
    end
    redirect_to queue_items_path
  end

  def destroy
    QueueItem.delete(params[:id])
    flash[:notice] = "You have removed a movie from your queue."
    current_user.normalize_queue_item_order_id
    redirect_to queue_items_path
  end

  private

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        item = QueueItem.find(queue_item_data[:id])
        item.update_attributes!(order_id: queue_item_data[:order_id]) if item.user == current_user
        video = Video.find(item.video_id)
        user_review = UserReview.where("user_id == #{session[:user_id]} AND video_id == #{item.video_id}")
        user_review.first.update_attributes(rating: queue_item_data[:rating]) if item.user == current_user
      end
    end
  end
end