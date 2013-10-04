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
  click_on "+ My Queue"
end

def login(user)
  visit "/login"
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  click_button "Sign In"
end