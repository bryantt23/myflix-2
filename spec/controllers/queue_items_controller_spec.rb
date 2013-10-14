  require 'spec_helper'

describe QueueItemsController do

  before { set_current_user }

  describe "GET show" do
    it "renders the show template" do
      get :index
      expect(response).to render_template :index
    end

    it "puts the videos in the queue in the correct order" do
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      video3 = Fabricate(:video)
      QueueItem.create(user_id: session[:user_id], video_id: video1.id, order_id: 2)
      QueueItem.create(user_id: session[:user_id], video_id: video2.id, order_id: 3)
      QueueItem.create(user_id: session[:user_id], video_id: video3.id, order_id: 1)
      get :index

      expect(assigns(:queue_items)).to eq([video3.queue_items, video1.queue_items, video2.queue_items].flatten)
    end
  end



  describe "POST create" do
    let(:video) { Fabricate(:video) }

    context "with valid input" do
      it "saves the queue in queue_items" do
        post :create, video_id: video
      end

      it "displays a notice" do
        post :create, video_id: video
        expect(flash[:notice]).to eq("You've added #{video.title} to your queue.")
      end

      it "redirects to the my_queues page" do
        post :create, video_id: video
        expect(response).to redirect_to queue_items_path
      end

      it "assigns the order_id to the first item in the queue to 1" do
        post :create, video_id: video
        expect(assigns(:queued_video).order_id).to eq(1)
      end

      it "assigns the order_id to the correct number when multiple items are in the queue" do
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
        post :create
        expect(QueueItem.count).to eq(0)
      end
      it "displays an error" do
        post :create
        expect(flash[:error]).to eq("Something went wrong.")
      end
      it "renders the video page" do
        post :create
        expect(response).to render_template :index
      end
    end
  end

  describe "DELETE destroy" do
    it "removes the desired video from the queue" do
      video = Fabricate(:video)
      queue_item = QueueItem.create(user_id: session[:user_id], video_id: video.id, order_id: 1)
      post :destroy, id: queue_item
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue itmes" do
      bob = current_user
      queue_item1 = Fabricate(:queue_item, user_id: bob.id, order_id: 1)
      queue_item2 = Fabricate(:queue_item, user_id: bob.id, order_id: 2)
      queue_item3 = Fabricate(:queue_item, user_id: bob.id, order_id: 3)
      post :destroy, id: queue_item1
      expect(bob.queue_items[0].order_id).to eq(1)
    end
  end

  describe "POST update" do
    let(:bob) { current_user }

    context "with valid input" do
      it "redirects to the queue items page" do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        user_review1 = Fabricate(:user_review, video_id: video1.id, user_id: session[:user_id], rating: 3)
        user_review2 = Fabricate(:user_review, video_id: video2.id, user_id: session[:user_id], rating: 4)
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1, video_id: video1.id)
        queue_item2 = Fabricate(:queue_item, user: bob, order_id: 2, video_id: video2.id)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 2},
                                          {id: queue_item2.id, order_id: 1}]
        expect(response).to redirect_to queue_items_path
      end

      it "it reorders the queue items" do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        user_review1 = Fabricate(:user_review, video_id: video1.id, user_id: session[:user_id], rating: 3)
        user_review2 = Fabricate(:user_review, video_id: video2.id, user_id: session[:user_id], rating: 4)
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1, video_id: video1.id)
        queue_item2 = Fabricate(:queue_item, user: bob, order_id: 2, video_id: video2.id)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 2},
                                          {id: queue_item2.id, order_id: 1}]
        expect(bob.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the order id numbers" do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        user_review1 = Fabricate(:user_review, video_id: video1.id, user_id: session[:user_id], rating: 3)
        user_review2 = Fabricate(:user_review, video_id: video2.id, user_id: session[:user_id], rating: 4)
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1, video_id: video1.id)
        queue_item2 = Fabricate(:queue_item, user: bob, order_id: 2, video_id: video2.id)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 15},
                                          {id: queue_item2.id, order_id: 6}]
        expect(bob.queue_items[0].order_id).to eq(1)
        expect(bob.queue_items[1].order_id).to eq(2)
      end

      it "updates the video's user review" do
        video = Fabricate(:video)
        user_review = Fabricate(:user_review, user_id: bob.id, video_id: video.id, rating: 4)
        queue_item1 = Fabricate(:queue_item, user: bob, video_id: video.id, order_id: 1)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 1, rating: 2}]
        expect(bob.queue_items[0].video.user_reviews.first.rating).to eq(2)
      end
    end

    context "with invalid input" do
      it "redirects to queue items page" do
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1)
        post :update_queue, queue_items:[{id: queue_item1.id, order_id: "FUDGE"}]
        expect(response).to redirect_to queue_items_path
      end
      it "sets the flash error message" do
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1)
        post :update_queue, queue_items:[{id: queue_item1.id, order_id: "FUDGE"}]
        expect(flash[:error]).to be_present
      end
      it "does not change the queue items" do
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        user_review1 = Fabricate(:user_review, video_id: video1.id, user_id: session[:user_id], rating: 3)
        user_review2 = Fabricate(:user_review, video_id: video2.id, user_id: session[:user_id], rating: 4)
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1, video_id: video1.id)
        queue_item2 = Fabricate(:queue_item, user: bob, order_id: 2, video_id: video2.id)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 3},
                                          {id: queue_item2.id, order_id: 6.8}]
        expect(queue_item1.reload.order_id).to eq(1)
      end
    end

    it_behaves_like "require_login" do
      let(:action) { post :update_queue, queue_items: [{id: 1, order_id: 3}, {id: 2, order_id: 4}] }
    end

    context "with queue items that do not belong to the current users" do
      it "does not change the queue items" do
        joe = Fabricate(:user)
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        user_review1 = Fabricate(:user_review, video_id: video1.id, user_id: session[:user_id], rating: 3)
        user_review2 = Fabricate(:user_review, video_id: video2.id, user_id: session[:user_id], rating: 4)
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1, video_id: video1.id)
        queue_item2 = Fabricate(:queue_item, user: joe, order_id: 2, video_id: video2.id)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 3},
                                          {id: queue_item2.id, order_id: 2}]
        expect(queue_item1.reload.order_id).to eq(1)
      end
    end
  end
end