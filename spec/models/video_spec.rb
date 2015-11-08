require "spec_helper"

describe Video do
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
end
