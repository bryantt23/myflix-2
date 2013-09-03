require 'spec_helper'

describe Category do

  it "saves itself" do
    cat = Category.new(name: "Action")
    cat.save
    Category.first.name.should == "Action"
  end

  it "has many videos" do
    cat = Category.new(name: "Action")
    vid1 = Video.new(title: 'Commando', description: 'Good one')
    vid2 = Video.new(title: 'Predator', description: 'Great one')
    vid3 = Video.new(title: 'Mission Impossible', description: 'Awesomeness')

    cat.save
    vid1.save
    vid2.save
    vid3.save

    vid1.categories << cat
    vid2.categories << cat
    vid3.categories << cat

    Category.first.videos.size.should == 3
  end
end