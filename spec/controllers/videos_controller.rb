require 'spec_helper'

describe VideosController do
  let!(:video) { Fabricate(:video, title:"The God Father") }

  describe "GET show" do
    context "for authecticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :show, { id: video.id }
      end

      it "sets the @video variable for authenticated user" do
        expect(assigns(:video)).to eq(video)
      end

      it "sets the @comment variable for authenticated user" do
        expect(assigns(:comment)).to be_instance_of(Comment)
      end

      it "gets the @video variable for authenticated user" do
        comment_1 = Fabricate(:comment, user_id: session[:user_id], video: video )
        comment_2 = Fabricate(:comment, user_id: session[:user_id], video: video )
        assigns(:video).comments.should =~ [comment_1, comment_2]
      end
    end

    context "for unauthenticated user" do
      it "redirect to sign in page" do
        get :show, { id: video.id }
        expect(response).to redirect_to sign_in_path
      end
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

  describe "POST comment" do
    context "for unauthenticated user" do
      before do
        post :comment, id: video, comment: Fabricate(:comment)
      end

      it "redirect to sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "no video added" do
        expect(video.comments.count).to eq(0)
      end
    end

    context "for authenticated user" do
      let(:user) { Fabricate(:user) }

      before { session[:user_id] = user.id }

      context "with valid inputs"  do
        before do
          post :comment, id: video, comment: Fabricate.attributes_for(:comment)
        end
        it "redirect to video show page" do
          expect(response).to redirect_to video
        end

        it "show flash message" do
          expect(flash[:info]).not_to be_blank
        end

        it "create a comment" do
          expect(Comment.count).to eq(1)
        end

        it "create a comment associated with the video" do
          expect(video.comments.count).to eq(1)
        end

        it "create a comment associated with the signed in user" do
          expect(user.comments.count).to eq(1)
        end
      end

      context "with invalid inputs" do
        before do
          post :comment, id: video, comment: { rate: 5 }
        end

        it "does not create a comment" do
          expect(Comment.count).to eq(0)
        end
        it "render the videos/show template" do
          expect(response).to render_template "videos/show"
        end

        it "set @video" do
          expect(assigns(:video)).to eq(video)
        end
      end
    end
  end
end
