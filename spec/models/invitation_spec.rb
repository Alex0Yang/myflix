require 'spec_helper'

describe Invitation do

  it "generate invite_token before create" do
    invitation = Fabricate(:invitation)
    expect(invitation.reload.invite_token).to be_present
  end

  it { should validate_presence_of :message }
  it { should validate_presence_of :friend_name }
  it { should validate_presence_of :friend_email }
end
