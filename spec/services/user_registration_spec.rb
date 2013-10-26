require 'spec_helper'

describe UserRegistration do
  describe "#register" do
    context "with valid personal info and credit card" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it "creates the user" do
        UserRegistration.new(Fabricate.build(:user)).register("stripe_token", nil)
        expect(User.count).to eq(1)
      end

      context "with valid input and an invitation" do

        it "makes the user follow the inviter" do
          bob = Fabricate(:user)
          invite = Fabricate(:invite, inviter: bob, invited_email: 'joe@example.com')
          UserRegistration.new(Fabricate.build(:user, email: "joe@example.com", full_name: 'Joe Smith',
                                password: 'password')).register("stripe_token", invite.token)
          joe = User.where(email: 'joe@example.com').first
          expect(joe.follows?(bob)).to be_true
        end

        it "makes the inviter follow the user" do
          bob = Fabricate(:user)
          invite = Fabricate(:invite, inviter: bob, invited_email: 'joe@example.com')
          UserRegistration.new(Fabricate.build(:user, email: "joe@example.com", full_name: 'Joe Smith',
                                password: 'password')).register("stripe_token", invite.token)
          joe = User.where(email: 'joe@example.com').first
          expect(bob.follows?(joe)).to be_true
        end

        it "expires the invitation upon acceptance" do
          bob = Fabricate(:user)
          invite = Fabricate(:invite, inviter: bob, invited_email: 'joe@example.com')
          UserRegistration.new(Fabricate.build(:user, email: "joe@example.com", full_name: 'Joe Smith',
                                password: 'password')).register("stripe_token", invite.token)
          joe = User.where(email: 'joe@example.com').first
          expect(Invite.first.token).to be_nil
        end
      end
    end

    context "with invalid personal info" do
      it "does not create user" do
        UserRegistration.new(Fabricate.build(:user, email: '')).register("stripe_token", nil)
        expect(User.count).to eq(0)
      end
    end

    context "sending confirmation emails" do

      let(:charge) { double(:charge, successful?: true) }
      before { StripeWrapper::Charge.stub(:create).and_return(charge) }
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        UserRegistration.new(Fabricate.build(:user, email: 'joe@example.com')).register("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        UserRegistration.new(Fabricate.build(:user, full_name: 'Joe Smith')).register("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('Joe Smith')
      end

      it "does not send out email with invalid inputs" do
        UserRegistration.new(Fabricate.build(:user, full_name: '')).register("stripe_token", nil)
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end