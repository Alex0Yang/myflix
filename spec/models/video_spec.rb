require "spec_helper"

describe Video do

  it { should belong_to(:category) }

  it { should validate_presence_of(:title) }

  it { should have_many(:comments).order('created_at desc') }

  it { should validate_presence_of(:description) }

  describe '.search_by_title' do
    let!(:video_1) do
      Fabricate(:video, title:"The Godfather", created_at: 1.day.ago)
    end
    let!(:video_2) do
      Fabricate(:video, title:"The Godfather: Part II",
                   created_at: 2.day.ago)
    end
    let!(:video_3) do
      Fabricate(:video, title:"City of God",
                   created_at: 3.day.ago)
    end
    let!(:video_4) do
      Fabricate(:video, title:"Life Is Beautiful",
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

  describe '.average_rage' do
    it "return none if no rate" do
      video = Fabricate(:video)
      expect(video.average_rate).to eq("none")
    end

    it "return avg rate (float) if have some comments" do
      video = Fabricate(:video)
      6.times.each do |i|
        Fabricate(:comment, rate: 2, video: video)
      end
      expect(video.average_rate).to eq(2.0)
    end
  end
end
