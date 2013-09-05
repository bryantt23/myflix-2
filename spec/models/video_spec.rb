require 'spec_helper'

describe Video do



  it 'saves itself' do
    video = Video.new(title: "Die Hard", description: "Action movie",
      small_cover_url: "die_hard_small.jpg", large_cover_url: "die_hard_large")
    video.save
    Video.first.title.should == "Die Hard"
  end

  it { should have_many(:categories).through(:videos_categories)}

  it { should validate_presence_of(:title) }

  it { should validate_presence_of(:description) }

  it 'can be found by title' do
    a = Video.new(title: "Die Hard", description: "Action Movie")
    b = Video.new(title: "Distant World", description: "Mystery")
    c = Video.new(title: "Lethal Weapon", description: "Action Movie")
    a.save
    b.save
    c.save
    searched_vids = Video.search_by_title("Die Hard")
    searched_vids.size.should == 1
  end

  it 'can be found by partial title' do
    a = Video.new(title: "Die Hard", description: "Action Movie")
    b = Video.new(title: "Distant World", description: "Mystery")
    c = Video.new(title: "Lethal Weapon", description: "Action Movie")
    a.save
    b.save
    c.save
    searched_vids = Video.search_by_title("Di")

    searched_vids.size.should == 2
  end

  it 'cannot be found with blank search terms' do
    a = Video.new(title: "Die Hard", description: "Action Movie")
    b = Video.new(title: "Distant World", description: "Mystery")
    c = Video.new(title: "Lethal Weapon", description: "Action Movie")
    a.save
    b.save
    c.save
    searched_vids = Video.search_by_title("")
    searched_vids.size.should == 0
  end
end