require "spec_helper"

describe Category do
  it "can have many videos" do
    should have_many(:videos)
  end

  describe "#recent_videos" do
    let!(:category_1) { Category.create(name:"category_1") }
    let!(:category_2) { Category.create(name:"category_2") }
    let!(:video_1) { Video.create(title:"1_The Godfather",
                                  description:"some details",
                                  category: category_1,
                                  created_at: 1.day.ago) }
    let!(:video_2) { Video.create(title:"2_The Godfather: Part II",
                                  description:"some details",
                                  category: category_1,
                                  created_at: 2.day.ago) }
    let!(:video_3) { Video.create(title:"3_City of God",
                                  description:"some details",
                                  category: category_1,
                                  created_at: 3.day.ago) }
    let!(:video_4) { Video.create(title:"4_Life Is Beautiful",
                                  description:"some details",
                                  category: category_1,
                                  created_at: 4.day.ago) }
    let!(:video_5) { Video.create(title:"5_The Godfather",
                                  description:"some details",
                                  category: category_1,
                                  created_at: 5.day.ago) }
    let!(:video_6) { Video.create(title:"6_The Godfather: Part II",
                                  category: category_1,
                                  description:"some details",
                                  created_at: 6.day.ago) }
    let!(:video_7) { Video.create(title:"7_City of God",
                                  category: category_1,
                                  description:"some details",
                                  created_at: 7.day.ago) }
    let!(:video_8) { Video.create(title:"8_Life Is Beautiful",
                                  description:"some details",
                                  category: category_2,
                                  created_at: 8.day.ago) }
    let!(:video_9) { Video.create(title:"9_Life Is Beautiful",
                                  description:"some details",
                                  category: category_2,
                                  created_at: 9.day.ago) }

    it "show all if nubmer less than six" do
      expect(category_2.recent_videos.size).to eq(2)
    end

    it "show the first six videos if number more than six" do
      expect(category_1.recent_videos.size).to eq(6)
    end

    it "show vidoes by order by time" do
      expect(category_2.recent_videos).to eq([video_8, video_9])
    end
  end
end
