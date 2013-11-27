require 'spec_helper'

describe Payment do

  it { should belong_to :user }

  describe "#to_dollar" do
    it "formats payment amount from cents to dollars" do
      payment = Payment.create(user: Fabricate(:user), amount: 300, reference_id: 'boo')
      expect(payment.to_dollar).to eq("$3.00")
    end
  end
end