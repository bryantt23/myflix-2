require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to the home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to videos_path
    end
  end

  describe 'POST create' do
    context "with valid credentials" do
      let(:bob) { Fabricate(:user) }
      before do
        Payment.create(user: bob,
                        amount: 300,
                        reference_id: "123")
        post :create, email: bob.email, password: bob.password
      end

      it "puts the signed in user in the session" do
        expect(session[:user_id]).to eq(bob.id)
      end

      it "redirects to the videos path" do
        expect(response).to redirect_to videos_path
      end

      it "sets the notice" do
        expect(flash[:notice]).to eq("You are signed in, enjoy!")
      end
    end

    context "with invalid credentials" do
      before do
        bob = Fabricate(:user)
        post :create, email: bob.email, password: bob.password + "asdfasdf"
      end

      it "shows error message" do
        expect(flash[:error]).to eq("Sorry, something's wrong with your email or password.")
      end

      it "redirects to the login page" do
        expect(response).to redirect_to login_path
      end
    end

    context "with expired subscription" do
      it "deactivates the user's account" do
        bob = Fabricate(:user)
        payment = Payment.create(user: bob,
                        amount: 300,
                        reference_id: "123",
                        created_at: 2.months.ago)
        post :create, email: bob.email, password: bob.password
        expect(bob.reload).to be_locked
      end

      it "sets the flash error message" do
        bob = Fabricate(:user)
        payment = Payment.create(user: bob,
                        amount: 300,
                        reference_id: "123",
                        created_at: 2.months.ago)
        post :create, email: bob.email, password: bob.password
        expect(flash[:error]).to be_present
      end
    end

    context "with locked account" do
      before { AppMailer.deliveries.clear }

      it "sends the notice email if account is locked" do
        bob = Fabricate(:user, locked: true)
        Payment.create(user: bob,
                        amount: 300,
                        reference_id: "123")
        post :create, email: bob.email, password: bob.password
        expect(AppMailer.deliveries.count).to eq(1)
      end
    end
  end

  describe 'GET destroy' do

    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "sets the session user_id to nil" do
      expect(session[:user_id]).to eq(nil)
    end

    it "redirects to the root path" do
      expect(response).to redirect_to root_path
    end

    it "sets the notice" do
      expect(flash[:notice]).to eq("You are signed out.")
    end
  end
end