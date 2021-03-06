require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:user) }
#  it { should validate_numericality_of(:position).only_integer}

  describe "#video_title" do
    it "returns the title of the video" do
      video = Fabricate(:video, title: "God")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("God")
    end
  end

  describe "#rating" do
    it "returns the rating of the video of queue_item" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      comment = Fabricate(:comment, user: user, video: video, rate: 4)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(4)
    end

    it "returns nil if no comment of the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to be_nil
    end

  end

  describe "#rating=" do
    it 'change the rating of the review if the review is present' do
      alice = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:comment, user: alice, video: video, rate: 3)
      queue_item = Fabricate(:queue_item, video: video, user: alice)
      queue_item.update_attributes(rating: 4)
      expect(queue_item.rating).to eq(4)
    end

    it 'clears the rating of the review if the review is present' do
      alice = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:comment, user: alice, video: video, rate: 3)
      queue_item = Fabricate(:queue_item, video: video, user: alice)
      queue_item.update_attributes(rating: "")
      expect(queue_item.rating).to eq(nil)
    end

    it 'creates a review with the rating if the review is not present' do
      alice = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: alice)
      queue_item.update_attributes(rating: 4)
      expect(queue_item.rating).to eq(4)
    end
  end

  describe "#category_name" do
    it "returns the category's name of the video" do
      category = Fabricate(:category, name: "war")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("war")
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end
