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
    it_behaves_like "require_admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      it "creates a video" do
        set_current_admin
        post :create, video: { title: 'Monk', description: 'good show!' }
        expect(Video.count).to eq(1)
      end

      it "creates a video" do
        set_current_admin
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :create, video: { title: 'Monk', description: 'good show!', category_ids: [category1.id, category2.id] }
        expect(category1.videos.size).to eq(1)
        expect(category2.videos.size).to eq(1)
      end

      it "flashes the success message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: 'Monk', description: 'good show!',
                               categories: category.id }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      it "does not create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: 'good stuff.',
                              categories: category.id }
        expect(category.videos.count).to eq(0)
      end

      it  "sets the variable" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: 'good stuff.',
                              categories: category.id }
        expect(assigns(:video)).to be_instance_of Video
      end

      it "flashes the error message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {description: 'good stuff.',
                              categories: category.id }
        expect(flash[:error]).to be_present
      end

      it "renders the new template" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {description: 'good stuff.',
                              categories: category.id }
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do
    it_behaves_like "require_admin" do
      let(:action) { get :edit, id: 1 }
    end

    it "sets the @video variable" do
      set_current_admin
      video = Fabricate(:video)
      get :edit, id: video.id
      expect(assigns(:video)).to eq(video)
    end
  end

  describe "POST update" do
    it_behaves_like "require_admin" do
       let(:action) { post :update, id: 1 }
    end

    context "with valid input" do
      it "sets the variable" do
        set_current_admin
        video = Fabricate(:video)
        post :update, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "updates the video attributes" do
        set_current_admin
        video = Fabricate(:video)
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :update, id: video.id, video: {category_ids: [category1.id, category2.id] }
        expect(video.categories).to eq([category1, category2])
      end


      it "redirects to the updated video path" do
        set_current_admin
        video = Fabricate(:video)
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :update, id: video.id, video: {category_ids: [category1.id, category2.id] }
        expect(response).to redirect_to video_path(video)
      end
    end

    context "with invalid input" do
      it "sets the variable" do
        set_current_admin
        video = Fabricate(:video)
        post :update, id: video.id, video: { title: '' }
        expect(assigns(:video)).to eq(video)
      end

      it "sets the flash message" do
        set_current_admin
        video = Fabricate(:video)
        post :update, id: video.id, video: { title: '' }
        expect(flash[:error]).to be_present
      end

      it "renders the edit page" do
        set_current_admin
        video = Fabricate(:video)
        post :update, id: video.id, video: { title: '' }
        expect(response).to render_template :edit
      end
    end
  end
end
