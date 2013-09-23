def set_current_user
  bob = Fabricate(:user)
  session[:user_id] = bob.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def create_videos_reviews_and_queue_items(bob)
  video1 = Fabricate(:video)
  video2 = Fabricate(:video)
  user_review1 = Fabricate(:user_review, video_id: video1.id, user_id: session[:user_id], rating: 3)
  user_review2 = Fabricate(:user_review, video_id: video2.id, user_id: session[:user_id], rating: 4)
  @queue_item1 = Fabricate(:queue_item, user: bob, order_id: 1, video_id: video1.id)
  @queue_item2 = Fabricate(:queue_item, user: bob, order_id: 2, video_id: video2.id)
end