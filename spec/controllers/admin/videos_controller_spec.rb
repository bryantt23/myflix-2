require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_login" do
      let(:action) { get :new }
    end

    it_behaves_like "require_admin" do
      let(:action) { get :new }
    end

    it "sets the @video variable to a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end

    it "sets the flash error message for regular user" do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end
  end

  describe "POST create" do
    context "with valid input" do
      it_behaves_like "require_admin" do
        let(:action) {post :create }
      end

      it "creates a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: 'Monk', description: 'good show!',
                               categories: [category.id] }
        expect(category.videos.count).to eq(1)
      end

      it "flashes the succes message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: 'Monk', description: 'good show!',
                               categories: [category.id] }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      it "does not create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {description: 'good stuff.',
                              categories: [category.id]}
        expect(category.videos.count).to eq(0)
      end

      it  "sets the variable" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {description: 'good stuff.',
                              categories: [category.id]}
        expect(assigns(:video)).to be_instance_of Video
      end
      it "flashes the error message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {description: 'good stuff.',
                              categories: [category.id]}
        expect(flash[:error]).to be_present
      end

      it "renders the new template" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {description: 'good stuff.',
                              categories: [category.id]}
        expect(response).to render_template :new
      end
    end
  end
end