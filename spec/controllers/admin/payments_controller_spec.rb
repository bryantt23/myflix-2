require 'spec_helper'

describe Admin::PaymentsController do
  describe "GET index" do
    it "sets the variable" do
      Payment.create(user: Fabricate(:user), amount: 300, reference_id: "boo!")
      get :index
      expect(assigns(:payments).count).to eq(1)
    end
  end
end