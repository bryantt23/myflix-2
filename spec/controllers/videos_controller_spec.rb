require 'spec_helper'

describe VideosController do

  before { set_current_user }

  describe "GET show" do
    it "sets @video for authenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @user_reviews for authenticated users" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      video = Fabricate(:video)
      review1 = Fabricate(:user_review, video: video, user_id: user1.id)
      review2 = Fabricate(:user_review, video: video, user_id: user2.id)
      get :show, id: video.id
      expect(assigns(:user_reviews)).to match_array([review1, review2])
    end

    it_behaves_like "require_login" do
      video = Fabricate(:video)
      let(:action) { get :show, id: video.id }
    end
  end

  describe "POST search" do
    it "sets @searched_videos for authenticated users" do
      futurama = Fabricate(:video, title: 'Futurama')
      post :search, search: "rama"
      expect(assigns(:searched_videos)).to eq([futurama])
    end
    it "redirects to sign in page for the unautheticated users" do
      clear_current_user
      futurama = Fabricate(:video, title: 'Futurama')
      post :search, search: "rama"
      expect(response).to redirect_to login_path
    end
  end
end