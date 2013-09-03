require 'spec_helper'

describe Video do

  it 'saves itself' do
    video = Video.new(title: "Die Hard", description: "Action movie",
      small_cover_url: "die_hard_small.jpg", large_cover_url: "die_hard_large")
    video.save
    Video.first.title.should == "Die Hard"
  end

  it 'belongs to a category' do
    video = Video.new(title: "Die Hard", description: "Action movie",
      small_cover_url: "die_hard_small.jpg", large_cover_url: "die_hard_large")
    category = Category.new(name: "Action")
    video.save
    category.save

    video = Video.first
    category = Category.first
    video.categories << category

    Video.first.categories.first.name.should == "Action"
  end

  it 'has a title' do
    video = Video.new(title: "Die Hard", description: "Action movie",
      small_cover_url: "die_hard_small.jpg", large_cover_url: "die_hard_large")
    video.save
    Video.first.title.should == "Die Hard"
  end

  it 'has a description' do
    video = Video.new(title: "Die Hard", description: "Action movie",
      small_cover_url: "die_hard_small.jpg", large_cover_url: "die_hard_large")
    video.save
    Video.first.description.should == "Action movie"
  end
end