require "spec_helper"

describe Video do

  it "belongs to category" do
    should belong_to(:category)
  end

  it "have a title" do
    should validate_presence_of(:title)
  end

  it "have description" do
    should validate_presence_of(:description)
  end

  describe '.search_by_title' do
    let!(:video_1) do
      Video.create(title:"The Godfather",
                  description:"some details",
                  created_at: 1.day.ago)
    end
    let!(:video_2) do
      Video.create(title:"The Godfather: Part II",
                   description:"some details",
                   created_at: 2.day.ago)
    end
    let!(:video_3) do
      Video.create(title:"City of God",
                   description:"some details",
                   created_at: 3.day.ago)
    end
    let!(:video_4) do
      Video.create(title:"Life Is Beautiful",
                   description:"some details",
                   created_at: 4.day.ago)
    end

    def search(search_terms)
      Video.search_by_title(search_terms)
    end

    it 'returns an empty array if there is no match'do
      expect(search("some")).to be_empty
    end

    it 'returns an array of one video for an exact match' do
      expect(search("City of God")).to match_array([video_3])
    end

    it 'returns an array of all match videos for a partial match' do
      expect(search("god")).to match_array([video_1, video_2, video_3])
    end

    it 'returns an array of all matches ordered by created_at' do
      expect(search("god")).to eq([video_1, video_2, video_3])
    end

    it 'returns an empty array for a search with an empty string' do
      expect(search("")).to be_empty
    end
  end
end
