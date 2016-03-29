require 'spec_helper'

describe Comment do
  it { should belong_to(:video) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:rate) }

  it { should validate_presence_of(:content) }

  it { should validate_presence_of(:user_id) }

  it { should validate_presence_of(:video_id) }

  describe "#video_title" do
    it "return the title of associated video" do
      monk = Fabricate(:video)
      comment = Fabricate(:comment, video: monk)
      expect(comment.video_title).to eq(monk.title)
    end
  end
end
