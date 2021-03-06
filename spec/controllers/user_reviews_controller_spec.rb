require 'spec_helper'

describe UserReviewsController do
  describe "POST create" do

    let(:video) { Fabricate(:video) }
    before { set_current_user }

    context "with authenticated users" do
      context "with valid inputs" do
        before do
          post :create, user_review: Fabricate.attributes_for(:user_review), video_id: video.id
        end

        it "redirects to the video show page" do
          expect(response).to redirect_to video
        end
        it "creates a review" do
          expect(UserReview.count).to eq(1)
        end
        it "creates a review associated with the video" do
          expect(UserReview.first.video).to eq(video)
        end
        it "creates a review associated with the signed in user" do
          expect(UserReview.first.user).to eq(current_user)
        end
      end

      context "with invalid inputs" do
        it "does not create a review" do
          post :create, user_review: {rating: 4}, video_id: video.id
          expect(UserReview.count).to eq(0)
        end
        it "renders the videos/show template" do
          post :create, user_review: {rating: 4}, video_id: video.id
          expect(response).to render_template "videos/show"
        end
        it "sets @video" do
          post :create, user_review: {rating: 4}, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "sets @user_reviews" do
          user_review = Fabricate(:user_review, video: video)
          post :create, user_review: {rating: 4}, video_id: video.id
          expect(assigns(:user_reviews)).to match_array([user_review])
        end
      end
    end
    it_behaves_like "require_login" do
      let(:action) { post :create, user_review: Fabricate.attributes_for(:user_review), video_id: video.id }
    end
  end
end