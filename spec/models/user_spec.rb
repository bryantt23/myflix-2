require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order(:order_id) }

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