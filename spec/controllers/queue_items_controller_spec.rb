require 'spec_helper'

describe QueueItemsController do
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
      QueueItem.create(user_id: session[:user_id], video_id: video1.id, order_id: 2)
      QueueItem.create(user_id: session[:user_id], video_id: video2.id, order_id: 3)
      QueueItem.create(user_id: session[:user_id], video_id: video3.id, order_id: 1)
      get :show, id: session[:user_id]

      expect(assigns(:queue_items)).to eq([video3.queue_items, video1.queue_items, video2.queue_items].flatten)
    end
  end



  describe "POST create" do
    let(:video) { Fabricate(:video) }

    context "with valid input" do
      it "saves the queue in queue_items" do
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
        expect(response).to redirect_to queue_item_path(session[:user_id])
      end

      it "assigns the order_id to the first item in the queue to 1" do
        session[:user_id] = Fabricate(:user).id
        post :create, video_id: video
        expect(assigns(:queued_video).order_id).to eq(1)
      end

      it "assigns the order_id to the correct number when multiple items are in the queue" do
        session[:user_id] = Fabricate(:user).id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        video3 = Fabricate(:video)
        QueueItem.create(user_id: session[:user_id], video_id: video1.id, order_id: 1)
        QueueItem.create(user_id: session[:user_id], video_id: video2.id, order_id: 2)
        QueueItem.create(user_id: session[:user_id], video_id: video3.id, order_id: 3)
        post :create, video_id: video
        expect(assigns(:queued_video).order_id).to eq(4)
      end
    end

    context "with invalid input" do
      it "does not save the information in my_queues" do
        session[:user_id] = Fabricate(:user).id
        post :create
        expect(QueueItem.count).to eq(0)
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

  describe "POST destroy" do
    it "removes the desired video from the queue" do
      video = Fabricate(:video)
      session[:user_id] = Fabricate(:user).id
      queue_item = QueueItem.create(user_id: session[:user_id], video_id: video.id, order_id: 1)
      post :destroy, id: queue_item
      expect(QueueItem.count).to eq(0)
    end
  end
end