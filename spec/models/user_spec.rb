require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:order_id) }
  it { should have_many(:user_reviews).order("created_at DESC") }

  it "generates a random token when the user is created" do
    bob = Fabricate(:user)
    expect(bob.token).to be_present
  end

  it "returns true when the user has queued the video already" do
    user = Fabricate(:user)
    video = Fabricate(:video)
    Fabricate(:queue_item, user: user, video: video)
    user.queued_video?(video).should be_true
  end

  it "returns false when the user has not queued the video yet" do
    user = Fabricate(:user)
    video = Fabricate(:video)
    user.queued_video?(video).should be_false
  end
end

describe "#follow" do
 it "follows another user" do
  bob = Fabricate(:user)
  joe = Fabricate(:user)
  bob.follow(joe)
  expect(bob.follows?(joe)).to be_true
 end

 it "does not follow one self" do
  bob = Fabricate(:user)
  bob.follow(bob)
  expect(bob.follows?(bob)).to be_false
 end
end


