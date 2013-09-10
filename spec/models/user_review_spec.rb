require 'spec_helper'

describe UserReview do

  it { should belong_to :user }

  it { should belong_to :video }

end