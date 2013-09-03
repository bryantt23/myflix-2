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
end