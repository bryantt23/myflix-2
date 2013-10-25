require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "successful user registration" do

      it "redirects to the login page" do
        result = double(:registration_result, successful?: true)
        UserRegistration.any_instance.should_receive(:register).and_return(result)
        post :create, user: {email: 'luke@stuff.com', password: 'password', full_name: 'luke tower'}
        expect(response).to redirect_to login_path
      end
    end

    context "failed user registration" do

      it "renders the :new template" do
        result = double(:registration_result, successful?: false, error_message: 'This is an error message.')
        UserRegistration.any_instance.should_receive(:register).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(response).to render_template :new
      end

      it "sets the flash error method" do
        result = double(:registration_result, successful?: false,error_message: 'This is an error message.')
        UserRegistration.any_instance.should_receive(:register).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(flash[:error]).to eq("This is an error message.")
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