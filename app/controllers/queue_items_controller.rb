class QueueItemsController < ApplicationController
  before_filter :require_user

  def show
    @queue_items = QueueItem.where("user_id == #{session[:user_id]}").order("order_id")
  end

  def create
    @queue_items = QueueItem.where("user_id == #{session[:user_id]}").order("order_id")

    if @queue_items.size == 0
      @queued_video = QueueItem.new(user_id: session[:user_id],
                                    video_id: params[:video_id],
                                    order_id: 1)
    else
      position = @queue_items.last.order_id + 1
      @queued_video = QueueItem.new(user_id: session[:user_id],
                                    video_id: params[:video_id],
                                    order_id: position)
    end

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

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_order_id
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "You must enter a whole number in the List Order column."
    end

    redirect_to queue_item_path(session[:user_id])
  end

  def destroy
    QueueItem.delete(params[:id])
    flash[:notice] = "You have removed a movie from your queue."
    current_user.normalize_queue_item_order_id
    redirect_to queue_item_path(session[:user_id])
  end

  private

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        item = QueueItem.find(queue_item_data[:id])
        item.update_attributes!(order_id: queue_item_data[:order_id]) if item.user == current_user
      end
    end
  end
end