require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do

      before do
        post :create, user: {email: 'luke@stuff.com', password: 'password', full_name: 'luke tower'}
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the login page" do
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid input" do

      before do
        post :create, user: {email: 'luke@stuff.com', password: 'password'}
      end

      it "does not create user" do
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require_login" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      set_current_user
      bob = Fabricate(:user)
      get :show, id: bob.id
      expect(assigns(:user)).to eq(bob)
    end
  end
end