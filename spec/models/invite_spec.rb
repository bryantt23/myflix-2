require 'spec_helper'

describe Invite do
  it { should validate_presence_of(:invited_email) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:invited_name) }
end