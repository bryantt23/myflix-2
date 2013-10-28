require 'spec_helper'

describe "create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_102pH0233pORRa8DqaJYyZaC",
      "created" => 1382814625,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_102pH0233pORRa8D7egD9GD5",
          "object" => "charge",
          "created" => 1382814625,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_102pH0233pORRa8Dg5QDIkDI",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 10,
            "exp_year" => 2015,
            "fingerprint" => "ZGYcRWNSyLuI5dWz",
            "customer" => "cus_2pH0idEksHualJ",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => nil,
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => true,
          "refunds" => [],
          "balance_transaction" => "txn_102pH0233pORRa8D4cotqmdD",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_2pH0idEksHualJ",
          "invoice" => "in_102pH0233pORRa8DBkqXERQn",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {}
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_2pH0Q45yNB6kKD"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    bob = Fabricate(:user, customer_token: "cus_2pH0idEksHualJ")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(bob)
  end

  it "creates the payment with the amount", :vcr do
    bob = Fabricate(:user, customer_token: "cus_2pH0idEksHualJ")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    bob = Fabricate(:user, customer_token: "cus_2pH0idEksHualJ")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_102pH0233pORRa8D7egD9GD5")
  end
end