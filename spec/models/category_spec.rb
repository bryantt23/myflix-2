require 'spec_helper'

describe Category do

  it { should have_many(:videos).through(:videos_categories) }

  it "uses the recent_videos method to get the most recent 6 videos" do
    action    = Category.create(name: "Action")
    avengers  = Video.create(title: "Avengers",
                             description: "Awesome",
                             categories: [action],
                             created_at: 7.days.ago)
    batman    = Video.create(title: "Batman",
                             description: "Awesome",
                             categories: [action],
                             created_at: 6.days.ago)
    commando  = Video.create(title: "Commando",
                             description: "Awesome",
                             categories: [action],
                             created_at: 5.days.ago)
    d_man     = Video.create(title: "Demolition Man",
                             description: "Awesome",
                             categories: [action],
                             created_at: 4.days.ago)
    encino    = Video.create(title: "Encino Man",
                             description: "Awesome",
                             categories: [action],
                             created_at: 3.days.ago)
    flash     = Video.create(title: "Flash",
                             description: "Awesome",
                             categories: [action],
                             created_at: 2.days.ago)
    garbage   = Video.create(title: "Garbage",
                             description: "Awesome",
                             categories: [action],
                             created_at: 1.days.ago)

    action.recent_videos.first.should == garbage
    action.recent_videos.last.should  == batman
    action.recent_videos.size.should  == 6
  end
end