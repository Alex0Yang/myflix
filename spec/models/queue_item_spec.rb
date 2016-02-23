require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:user) }
 # it { should validate_numericality_of(:position).only_integer }

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

  describe "#update_queue" do
    it "update one recored" do
      item = Fabricate(:queue_item, position: 3)
      params = { item.id => { "position" => 4 }}
      QueueItem.update_queue(params)
      expect(item.reload.position).to eq(4)
    end

    it "update many recoreds if all valid" do
      update_params = {}
      update_params[:queue_item] = {}
      5.times.each do |i|
        item = Fabricate(:queue_item, position: 3)
        update_params[:queue_item].merge!( { item.id => { "position" => 4 } } )
      end
      QueueItem.update_queue(update_params[:queue_item])
      expect(QueueItem.all.map(&:position)).to eq( [4] * 5 )
    end

    it "cannot update recoreds if one is not integer" do
      update_params = {}
      update_params[:queue_item] = {}
      5.times.each do |i|
        new_position = 4
        new_position = 1.5 if i == 2
        item = Fabricate(:queue_item, position: 3)
        update_params[:queue_item].merge!( { item.id => { "position" => new_position } } )
      end
      QueueItem.update_queue(update_params[:queue_item])
      expect(QueueItem.all.map(&:position)).to eq( [3] * 5 )
    end

  end
end
