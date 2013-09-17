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
      MyQueue.create(user_id: session[:user_id], video_id: video1.id, order_id: 2)
      MyQueue.create(user_id: session[:user_id], video_id: video2.id, order_id: 3)
      MyQueue.create(user_id: session[:user_id], video_id: video3.id, order_id: 1)
      get :show, id: session[:user_id]

      expect(assigns(:queue)).to eq([video3.my_queues, video1.my_queues, video2.my_queues].flatten)
    end
  end



  describe "POST create" do
    let(:video) { Fabricate(:video) }

    context "with valid input" do
      it "saves the queue in my_queues" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video
      end

      it "displays a notice" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video
        expect(flash[:notice]).to eq("You've added #{video.title} movie to your queue.")
      end

      it "redirects to the my_queues page" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video
        expect(response).to redirect_to my_queue_path(session[:user_id])
      end
    end

    context "with invalid input" do
      it "does not save the information in my_queues" do
        session[:user_id] = Fabricate(:user).id
        post :create
        expect(MyQueue.count).to eq(0)
      end
      it "displays an error" do
        session[:user_id] = Fabricate(:user).id
        post :create
        expect(flash[:error]).to eq("Something went wrong.")
      end
      it "renders the video page" do
        session[:user_id] = Fabricate(:user).id
        post :create
        expect(response).to render_template :show
      end
    end
  end

  describe "POST update" do
    it "modifies the order_id of the queue" do
      session[:user_id] = Fabricate(:user).id
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      video3 = Fabricate(:video)
      queued1 = MyQueue.create(user_id: session[:user_id], video_id: video3.id, order_id: 1)
      queued2 = MyQueue.create(user_id: session[:user_id], video_id: video1.id, order_id: 2)
      queued3 = MyQueue.create(user_id: session[:user_id], video_id: video2.id, order_id: 3)
      queued1.order_id = 2
      post :update, queued_videos:key => "value",
      expect(assigns(:queue)).to eq([video2.my_queues, video1.my_queues, video3.my_queues].flatten)
    end
    it "displays the new queue on the my_queues page"
  end
end