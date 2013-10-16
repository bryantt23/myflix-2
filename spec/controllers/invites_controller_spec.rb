require 'spec_helper'

describe InvitesController do
  describe "GET new" do
    it "sets @invite to a new instance of invite model" do
      set_current_user
      get :new
      expect(assigns(:invite)).to be_instance_of(Invite)
    end

    it_behaves_like "require_login" do
      let(:action) { get :new  }
    end
  end

  describe "POST create" do

    before { set_current_user }

    it_behaves_like "require_login" do
      let(:action) { post :create }
    end

    context "with valid input" do
      it "redirects to the invite page" do
        post :create, invite: { invited_name: 'Joe',
                                invited_email: 'joe@example.com',
                                message: "Join MyFlix!"}
        expect(response).to redirect_to new_invite_path
      end

      it "saves the invitation in the database" do
        post :create, invite: { invited_name: 'Joe',
                                invited_email: 'joe@example.com',
                                message: "Join MyFlix!"}
        expect(Invite.count).to eq(1)
      end

      it "sends an email to the invited person" do
        post :create, invite: { invited_name: 'Joe',
                                invited_email: 'joe@example.com',
                                message: "Join MyFlix!"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sets the flash success message" do
        post :create, invite: { invited_name: 'Joe',
                                invited_email: 'joe@example.com',
                                message: "Join MyFlix!"}
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do

      after { ActionMailer::Base.deliveries.clear }

      it "renders the new page" do
        post :create, invite: { invited_name: 'Joe', message: "Join MyFlix!"}
        expect(response).to render_template(:new)
      end

      it "does not save the invitation" do
        post :create, invite: { invited_name: 'Joe', message: "Join MyFlix!"}
        expect(Invite.count).to eq(0)
      end

      it "does not send an email" do
        post :create, invite: { invited_name: 'Joe', message: "Join MyFlix!"}
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it "set the error message" do
        post :create, invite: { invited_name: 'Joe', message: "Join MyFlix!"}
        expect(flash[:error]).to be_present
      end

      it "sets @invite" do
        post :create, invite: { invited_name: 'Joe', message: "Join MyFlix!"}
        expect(assigns(:invite)).to be_present
      end
    end
  end
end