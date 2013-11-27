require 'spec_helper'

describe "deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_102tnD233pORRa8DQ6NnJXXy",
      "created" => 1383857051,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_102tnD233pORRa8D6W7M1UmB",
          "object" => "charge",
          "created" => 1383857051,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_102tnD233pORRa8DPFN1NqYJ",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 11,
            "exp_year" => 2016,
            "fingerprint" => "ZnNr1nMPuvSuM7G6",
            "customer" => "cus_2pjq3cVeEqk6KR",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_2pjq3cVeEqk6KR",
          "invoice" => nil,
          "description" => "failed charge",
          "dispute" => nil,
          "metadata" => {}
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_2tnDzm41WoWyld"
    }
  end

  it 'deactivates a user with the web hook data from stripe for a charge failed', :vcr do
    bob = Fabricate(:user, customer_token: "cus_2pjq3cVeEqk6KR")
    post "/stripe_events",  event_data
    expect(bob.reload).to be_locked
  end
end