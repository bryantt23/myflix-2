require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      card: {
        number: '4242424242424242',
        exp_month: 3,
        exp_year: 2016,
        cvc: 314
      }
    ).id
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      card: {
        number: '4000000000000002',
        exp_month: 3,
        exp_year: 2016,
        cvc: 314
      }
    ).id
  end

  describe StripeWrapper::Charge do
    before do
      StripeWrapper.set_api_key
    end

    describe ".create" do
      context "with valid credit card" do
        it "charges the card successfully", :vcr do
          response = StripeWrapper::Charge.create(amount: 300, card: valid_token)
          response.should be_successful
        end
      end

      context "with invalid credit card" do
        let(:response) { StripeWrapper::Charge.create(amount: 300, card: declined_card_token) }

        it "does not charge the card", :vcr do
          response.should_not be_successful
        end

        it "sets the error message", :vcr do
          response.error_message.should == "Your card was declined."
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    before do
      StripeWrapper.set_api_key
    end

    describe ".create" do
      it "creates a customer with a valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(user: alice, card: valid_token)
        expect(response).to be_successful
      end

      it "does not create a customer with a declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(user: alice, card: declined_card_token)
        expect(response).not_to be_successful
      end

      it "returns the error message for declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(user: alice, card: declined_card_token)
        expect(response.error_message).to eq('Your card was declined.')
      end

      it "returns the customer token for a valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(user: alice, card: valid_token)
        expect(response.customer_token).to be_present
      end
    end

    describe ".cancel_service" do
      it "cancels the customers subscription at next pay date", :vcr do
        alice = Fabricate(:user)
        customer = StripeWrapper::Customer.create(user: alice, card: valid_token)
        response = StripeWrapper::Customer.cancel_service(customer.customer_token)
        expect(response.cancel_at_period_end).to eq(true)
      end
    end
  end
end