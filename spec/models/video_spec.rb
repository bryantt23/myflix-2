require 'spec_helper'

describe Video do

  it { should have_many(:categories).through(:videos_categories)}
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:user_reviews).order("created_at DESC") }
  it { should have_many :my_queues}

  it 'can be found by title' do
    Video.create(title: "Die Hard", description: "Action Movie")
    Video.create(title: "Distant World", description: "Mystery")
    Video.create(title: "Lethal Weapon", description: "Action Movie")
    searched_vids = Video.search_by_title("Die Hard")
    searched_vids.size.should == 1
  end

  it 'can be found by partial title' do
    Video.create(title: "Die Hard", description: "Action Movie")
    Video.create(title: "Distant World", description: "Mystery")
    Video.create(title: "Lethal Weapon", description: "Action Movie")
    searched_vids = Video.search_by_title("Di")
    searched_vids.size.should == 2
  end

  it 'cannot be found with blank search terms' do
    Video.create(title: "Die Hard", description: "Action Movie")
    Video.create(title: "Distant World", description: "Mystery")
    Video.create(title: "Lethal Weapon", description: "Action Movie")
    searched_vids = Video.search_by_title("")
    searched_vids.size.should == 0
  end
end