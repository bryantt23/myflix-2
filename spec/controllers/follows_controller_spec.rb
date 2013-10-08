require 'spec_helper'

describe FollowsController do
  describe "GET index" do
    it "sets @followings to current user's following relationships" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      steve = Fabricate(:user)
      relationship = Fabricate(:follow, follower: bob, followed: steve)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require_login" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require_login" do
      let(:action) { delete :destroy, id: 4 }
    end
    it "deletes the relationship if the current user is the follower" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      steve = Fabricate(:user)
      relationship = Fabricate(:follow, follower: bob, followed: steve)
      delete :destroy, id: steve.id
      expect(Follow.count).to eq(0)
    end
    it "redirects to the people page" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      steve = Fabricate(:user)
      relationship = Fabricate(:follow, follower: bob, followed: steve)
      delete :destroy, id: steve.id
      expect(response).to redirect_to people_path
    end
    it "does not delete the relationship if the current user is not the follower" do
      bob = Fabricate(:user)
      rick = Fabricate(:user)
      session[:user_id] = rick.id
      steve = Fabricate(:user)
      relationship = Fabricate(:follow, follower: bob, followed: steve)
      delete :destroy, id: steve.id
      expect(Follow.count).to eq(1)
    end
  end

  describe "POST create" do
    it "saves the relationship" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      steve = Fabricate(:user)
      post :create, followed_id: steve.id
      expect(Follow.count).to eq(1)
    end
    it "sets the notice if relationship is saved successfully" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      steve = Fabricate(:user)
      post :create, followed_id: steve.id
      expect(flash[:notice]).to eq("You are now following #{steve.full_name}")
    end
    it "does not save the relationship if it already exists" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      steve = Fabricate(:user)
      relationship = Fabricate(:follow, follower: bob, followed: steve)
      post :create, followed_id: steve.id
      expect(Follow.count).to eq(1)
    end
    it "sets the error if relationship is not saved successfully" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      steve = Fabricate(:user)
      relationship = Fabricate(:follow, follower: bob, followed: steve)
      post :create, followed_id: steve.id
      expect(flash[:error]).to eq("Unable to follow.")
    end
  end
end