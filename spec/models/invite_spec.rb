require 'spec_helper'

describe Invite do
  it { should validate_presence_of(:invited_email) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:invited_name) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invite) }
  end
end