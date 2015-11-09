require "spec_helper"

describe Video do
  let(:new_category) { Category.create(name: "TV Commedies") }

  it "can save self" do
    title = "new_video"
    description = "new_video_description"
    small_cover_url =  "small_cover_url_video"
    large_cover_url =  "large_cover_url_video"

    video = Video.new(title: title,
                      description: description,
                      small_cover_url: small_cover_url,
                      large_cover_url: large_cover_url,
                     )
    video.save
    last_video = Video.last
    expect(last_video.title).to eq(title)
    expect(last_video.description).to eq(description)
    expect(last_video.small_cover_url).to eq(small_cover_url)
    expect(last_video.large_cover_url).to eq(large_cover_url)
  end

  it "belongs to category" do
    video = Video.create(title:"new_video", category: new_category)
    expect(video.category).to eq(new_category)
  end

  it "if have title and description, should be valid" do
    video = Video.create(title:"new video", description: "some details")
    expect(Video.first).to eq(video)
  end

  it 'it has no either title or description ' do
    video_1 = Video.create(title:"new video")
    video_2 = Video.create(description: "some details")
    video_1.valid?
    video_2.valid?
    expect(video_1.errors[:description].size).to eq(1)
    expect(video_2.errors[:title].size).to eq(1)
  end

end
