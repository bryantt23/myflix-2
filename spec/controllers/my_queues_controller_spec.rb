require 'spec_helper'

describe MyQueuesController do
  describe "GET show" do
    it "renders the show template" do
      session[:user_id] = Fabricate(:user).id
      get :show, id: session[:user_id]
      expect(response).to render_template :show
    end

    it "puts the videos in the queue in the correct order" do
      session[:user_id] = Fabricate(:user).id
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      video3 = Fabricate(:video)
      MyQueue.create(user_id: session[:user_id], video_id: video1.id, order: 2)
      MyQueue.create(user_id: session[:user_id], video_id: video2.id, order: 3)
      MyQueue.create(user_id: session[:user_id], video_id: video3.id, order: 1)
      get :show, id: session[:user_id]
      binding.pry
      expect(assigns(:queue[0])).to eq(video3)
      expect(assigns(:queue[1])).to eq(video1)
      expect(assigns(:queue[2])).to eq(video2)
    end
  end

  describe "POST update" do
    it ""
  end
end