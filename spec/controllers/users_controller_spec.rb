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

      let(:charge) { double(:charge, successful?: true) }
      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: {email: 'luke@stuff.com', password: 'password', full_name: 'luke tower'}
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the login page" do
        expect(response).to redirect_to login_path
      end

    context "with valid input and an invitation" do

        it "makes the user follow the inviter" do
          bob = Fabricate(:user)
          invite = Fabricate(:invite, inviter: bob, invited_email: 'joe@example.com')
          post :create, user: { email: "joe@example.com", full_name: 'Joe Smith',
                                password: 'password'}, invite_token: invite.token
          joe = User.where(email: 'joe@example.com').first
          expect(joe.follows?(bob)).to be_true
        end

        it "makes the inviter follow the user" do
          bob = Fabricate(:user)
          invite = Fabricate(:invite, inviter: bob, invited_email: 'joe@example.com')
          post :create, user: { email: "joe@example.com", full_name: 'Joe Smith',
                                password: 'password'}, invite_token: invite.token
          joe = User.where(email: 'joe@example.com').first
          expect(bob.follows?(joe)).to be_true
        end

        it "expires the invitation upon acceptance" do
          bob = Fabricate(:user)
          invite = Fabricate(:invite, inviter: bob, invited_email: 'joe@example.com')
          post :create, user: { email: "joe@example.com", full_name: 'Joe Smith',
                                password: 'password'}, invite_token: invite.token
          joe = User.where(email: 'joe@example.com').first
          expect(Invite.first.token).to be_nil
        end
      end
    end

    context "sending confirmation emails" do

      let(:charge) { double(:charge, successful?: true) }
      before { StripeWrapper::Charge.stub(:create).and_return(charge) }
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Smith'}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: 'joe@example.com', password: 'password', full_name: 'Joe Smith'}
        expect(ActionMailer::Base.deliveries.last.body).to include('Joe Smith')
      end

      it "does not send out email with valid inputs" do
        post :create, user: { email: 'joe@example.com', full_name: 'Joe Smith'}
        expect(ActionMailer::Base.deliveries.count).to eq(0)
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

  describe "GET new_with_invite_token" do
    it "renders the :new view template" do
      invite = Fabricate(:invite)
      get :new_with_invite_token, token: invite.token
      expect(response).to render_template :new
    end

    it "sets @user with invited's email address" do
      invite = Fabricate(:invite)
      get :new_with_invite_token, token: invite.token
      expect(assigns(:user).email).to eq(invite.invited_email)
    end

    it "sets @invite_token" do
      invite = Fabricate(:invite)
      get :new_with_invite_token, token: invite.token
      expect(assigns(:invite_token)).to eq(invite.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invite_token, token: "asdfdfs0"
      expect(response).to redirect_to expired_token_path
    end
  end
end