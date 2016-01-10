require 'spec_helper'

describe Comment do
  it { should belong_to(:video) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:rate) }

  it { should validate_presence_of(:review) }

  it { should validate_presence_of(:user_id) }

  it { should validate_presence_of(:video_id) }
end
