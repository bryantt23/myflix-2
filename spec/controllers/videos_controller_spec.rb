require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      binding.pry
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:user_review, video: video)
      review2 = Fabricate(:user_review, video: video)
      get :show, id: video.id
      expect(assigns(:user_reviews)).to match_array([review1, review2])
    end

    it "redirects user to the sign in page for  unautheticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to login_path
    end
  end

  describe "POST search" do
    it "sets @searched_videos for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: 'Futurama')
      post :search, search: "rama"
      expect(assigns(:searched_videos)).to eq([futurama])
    end
    it "redirects to sign in page for the unautheticated users" do
      futurama = Fabricate(:video, title: 'Futurama')
      post :search, search: "rama"
      expect(response).to redirect_to login_path
    end
  end
end