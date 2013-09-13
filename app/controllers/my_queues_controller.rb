class MyQueuesController < ApplicationController

  def show
    @queue = MyQueue.where("user_id == #{session[:user_id]}").order("order_id")
  end
end