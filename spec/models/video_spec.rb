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
  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end

      context "with title and description" do
        it "returns an array of many videos based for title and description match" do
          star_wars = Fabricate(:video, title: "Star Wars")
          about_sun = Fabricate(:video, description: "sun is a star")
          refresh_index

          expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
        end
      end

      context "multiple words must match" do
        it "returns an array of videos where 2 words match title" do
          star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
          star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
          bride_wars = Fabricate(:video, title: "Bride Wars")
          star_trek = Fabricate(:video, title: "Star Trek")
          refresh_index

          expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
        end
      end

      context "with title, description and reviews" do
        it 'returns an an empty array for no match with reviews option' do
          star_wars = Fabricate(:video, title: "Star Wars")
          batman    = Fabricate(:video, title: "Batman")
          batman_review = Fabricate(:comment, video: batman, content: "such a star movie!")
          refresh_index

          expect(Video.search("no_match", comments: true).records.to_a).to eq([])
        end

        it 'returns an array of many videos with relevance title > description > review' do
          star_wars = Fabricate(:video, title: "Star Wars")
          about_sun = Fabricate(:video, description: "the sun is a star!")
          batman    = Fabricate(:video, title: "Batman")
          batman_review = Fabricate(:comment, video: batman, content: "such a star movie!")
          refresh_index

          expect(Video.search("star", comments: true).records.to_a).to eq([star_wars, about_sun, batman])
        end
      end


    end
  end
end
