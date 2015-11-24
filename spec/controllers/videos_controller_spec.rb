require 'spec_helper'

describe VideosController do
  let!(:video) { Fabricate(:video, title:"The God Father") }

  describe "GET show" do

    it "sets the @video variable for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :show, { id: video.id }
      expect(assigns(:video)).to eq(video)
    end

    it "redirect to sign in page for unauthenticated user" do
      get :show, { id: video.id }
      expect(response).to redirect_to sign_in_path
    end

  end

  describe "GET search" do

    it "sets the @search_result variable for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :search, { title: "god" }
      expect(assigns(:search_result)).to eq([video])
    end

    it "redirect to sign in page for unauthenticated user" do
      get :search, { id: video.id }
      expect(response).to redirect_to sign_in_path
    end
  end
end
