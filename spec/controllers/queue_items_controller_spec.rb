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

  describe "DELETE destroy" do
    it "removes the desired video from the queue" do
      video = Fabricate(:video)
      session[:user_id] = Fabricate(:user).id
      queue_item = QueueItem.create(user_id: session[:user_id], video_id: video.id, order_id: 1)
      post :destroy, id: queue_item
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue itmes" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      queue_item1 = Fabricate(:queue_item, user_id: bob.id, order_id: 1)
      queue_item2 = Fabricate(:queue_item, user_id: bob.id, order_id: 2)
      queue_item3 = Fabricate(:queue_item, user_id: bob.id, order_id: 3)
      post :destroy, id: queue_item1
      expect(bob.queue_items[0].order_id).to eq(1)
    end
  end

  describe "POST update" do
    context "with valid input" do
      it "redirects to the queue items page" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        user_review1 = Fabricate(:user_review, video_id: video1.id, user_id: session[:user_id], rating: 3)
        user_review2 = Fabricate(:user_review, video_id: video2.id, user_id: session[:user_id], rating: 4)
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1, video_id: video1.id)
        queue_item2 = Fabricate(:queue_item, user: bob, order_id: 2, video_id: video2.id)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 2},
                                          {id: queue_item2.id, order_id: 1}]
        expect(response).to redirect_to queue_item_path(bob.id)
      end

      it "it reorders the queue items" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
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
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        user_review1 = Fabricate(:user_review, video_id: video1.id, user_id: session[:user_id])
        user_review2 = Fabricate(:user_review, video_id: video2.id, user_id: session[:user_id])
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1, video_id: video1.id)
        queue_item2 = Fabricate(:queue_item, user: bob, order_id: 2, video_id: video2.id)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 15},
                                          {id: queue_item2.id, order_id: 6}]
        expect(bob.queue_items[0].order_id).to eq(1)
        expect(bob.queue_items[1].order_id).to eq(2)
      end

      it "updates the video's user review" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video = Fabricate(:video)
        user_review = Fabricate(:user_review, user_id: bob.id, video_id: video.id, rating: 4)
        queue_item1 = Fabricate(:queue_item, user: bob, video_id: video.id, order_id: 1)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 1, rating: 2}]
        expect(bob.queue_items[0].video.user_reviews.first.rating).to eq(2)
      end
    end

    context "with invalid input" do
      it "redirects to queue items page" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1)
        post :update_queue, queue_items:[{id: queue_item1.id, order_id: "FUDGE"}]
        expect(response).to redirect_to queue_item_path(session[:user_id])
      end
      it "sets the flash error message" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1)
        post :update_queue, queue_items:[{id: queue_item1.id, order_id: "FUDGE"}]
        expect(flash[:error]).to be_present
      end
      it "does not change the queue items" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        user_review1 = Fabricate(:user_review, video_id: video1.id, user_id: session[:user_id])
        user_review2 = Fabricate(:user_review, video_id: video2.id, user_id: session[:user_id])
        queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1, video_id: video1.id)
        queue_item2 = Fabricate(:queue_item, user: bob, order_id: 2, video_id: video2.id)
        post :update_queue, queue_items: [{id: queue_item1.id, order_id: 3},
                                          {id: queue_item2.id, order_id: 6.8}]
        expect(queue_item1.reload.order_id).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirect to the login path" do
        post :update_queue, queue_items: [{id: 1, order_id: 3}, {id: 2, order_id: 4}]
        expect(response).to redirect_to login_path
      end
    end

    context "with queue items that do not belong to the current users" do
      it "does not change the queue items" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
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