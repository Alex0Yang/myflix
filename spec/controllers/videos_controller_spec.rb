require 'spec_helper'

describe VideosController do
  let(:user) { Fabricate(:user) }
  before { session[:user_id] = user.id }

  describe "GET show" do
    let!(:video) { Fabricate(:video) }

    it "sets the @video variable" do
      get :show, { id: Video.first.id }
      expect(assigns(:video)).to eq(video)
    end

    it "renders the show template" do
      get :show, { id: Video.first.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET search" do
    let!(:video) { Fabricate(:video, title:"The God Father") }

    it "sets the @search_result variable" do
      get :search, { title: "god"}
      expect(assigns(:search_result)).to eq([video])
    end

    it "renders the show template" do
      get :search, { title: "god"}
      expect(assigns(:search)).to render_template(:search)
    end
  end
end
