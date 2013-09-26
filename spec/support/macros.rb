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

def add_video_to_queue(video)
  visit root_path
  click_on "video_#{video.id}"
  click_on "Add to My Queue"
end