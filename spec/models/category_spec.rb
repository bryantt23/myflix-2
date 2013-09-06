require 'spec_helper'

describe Category do

  it "saves itself" do
    cat = Category.new(name: "Action")
    cat.save
    Category.first.name.should == "Action"
  end

  it { should have_many(:videos).through(:videos_categories) }

  it "gets the most recent 6 videos" do
    a = Video.new(title: "Avengers", description: "Awesome")
    a.save
    b = Video.new(title: "Batman", description: "Awesome")
    b.save
    c = Video.new(title: "Commando", description: "Awesome")
    c.save
    d = Video.new(title: "Demolition Man", description: "Awesome")
    d.save
    e = Video.new(title: "Encino Man", description: "Awesome")
    e.save
    cat = Category.new(name: "Action")
    cat.save

    cat.videos << a
    cat.videos << b
    cat.videos << c
    cat.videos << d
    cat.videos << e

    cat.recent_videos.first.should == e
    cat.recent_videos.last.should == a
    cat.recent_videos.size.should == 5
  end
end