require "spec_helper"

describe Category do
  let(:category) { Category.new(name: "TV Commedies") }
  let(:video_1)  { Video.create(title: "video_1", description: "some details") }
  let(:video_2)  { Video.create(title: "video_2", description: "some details") }

  context "When create a new category," do
    it "can save itself" do
      category.save
      expect(Category.last).to eq(category)
    end

    it "can have many videos" do
      [video_1, video_2].each { |video| video.category = category; video.save }
      category.save
      expect(category.videos).to eq([video_1, video_2])
    end

  end
end
