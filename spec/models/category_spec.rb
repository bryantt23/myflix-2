require 'spec_helper'

describe Category do

  it "saves itself" do
    cat = Category.new(name: "Action")
    cat.save
    Category.first.name.should == "Action"
  end

  it { should have_many(:videos).through(:videos_categories) }

end