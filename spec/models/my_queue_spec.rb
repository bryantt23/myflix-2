require 'spec_helper'

describe MyQueue do

  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :video_id }
  it { should validate_presence_of :order }

end