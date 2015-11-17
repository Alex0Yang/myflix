require "spec_helper"

describe Category do
  it "can have many videos" do
    should have_many(:videos)
  end

  describe "#recent_videos" do
    let!(:category_1) { Category.create(name:"category_1") }
    let!(:category_2) { Category.create(name:"category_2") }
    let!(:category_3) { Category.create(name:"category_3") }

    let!(:video_1) do
      Video.create(title:"1_The Godfather",
                   description:"some details",
                   category: category_1,
                   created_at: 1.day.ago)
    end

    let!(:video_2) do
      Video.create(title:"2_The Godfather: Part II",
                    description:"some details",
                    category: category_1,
                    created_at: 2.day.ago)
    end
    let!(:video_3) do
      Video.create(title:"3_City of God",
                    description:"some details",
                    category: category_1,
                    created_at: 3.day.ago)
    end
    let!(:video_4) do
      Video.create(title:"4_Life Is Beautiful",
                   description:"some details",
                   category: category_1,
                   created_at: 4.day.ago)
    end
    let!(:video_5) do
      Video.create(title:"5_The Godfather",
                   description:"some details",
                   category: category_1,
                   created_at: 5.day.ago)
    end
    let!(:video_6) do
      Video.create(title:"6_The Godfather: Part II",
                   category: category_1,
                   description:"some details",
                   created_at: 6.day.ago)
    end
    let!(:video_7) do
      Video.create(title:"7_City of God",
                    category: category_1,
                    description:"some details",
                    created_at: 7.day.ago)
    end
    let!(:video_8) do
      Video.create(title:"8_Life Is Beautiful",
                    description:"some details",
                    category: category_2,
                    created_at: 8.day.ago)
    end
    let!(:video_9) do
      Video.create(title:"9_Life Is Beautiful",
                    description:"some details",
                    category: category_2,
                    created_at: 9.day.ago)
    end

    it "show all if nubmer less than six" do
      expect(category_2.recent_videos.size).to eq(2)
    end

    it "show the first six videos if number more than six" do
      expect(category_1.recent_videos.size).to eq(6)
    end

=begin
  #Tealeaf kevin's solution

  it "returns 6 videos if there are more than 6 vidoes" do
    comedies = Category.create!(name: "comedies")
    7.times { Video.create(title: "foo", description: "bar", category: comedies) }
    expect(comedies.recent_videos.count).to eq(6)
  end

  it "returns most recent 6 videos" do
    comedies = Category.create!(name: "comedies")
    6.times { Video.create(title: "foo", description: "bar", category: comedies) }
    tonight_show = Video.create!(title: "Tonight show", description: "Talk show", category: comedies, created_at: 2.day.ago)
    expect(comedies.recent_videos).not_to include(tonight_show)
  end

  两个测试都已经通过，第二个测试发现了一个隐藏的bug
  把kevin的solution放在的原因是他用的方法比我简单很多，7.times省略了很多事情
=end

    it "show vidoes by order by time" do
      expect(category_2.recent_videos).to eq([video_8, video_9])
    end

    it 'returns an empty array if the category dose not have any videos' do
      expect(category_3.recent_videos.size).to eq(0)
    end

    it 'returns the most recent 6 videos' do
      expect(category_1.recent_videos).not_to include(video_7)
    end
  end
end
