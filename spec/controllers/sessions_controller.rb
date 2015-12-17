require 'spec_helper'

describe SessionsController do
  describe "GET front" do
    it "render front for unauthenticated user" do
      get :front
      expect(response).to render_template :front
    end

    it "redirect to videos path for authenticated user" do
      session[:user_id] = Fabricate(:user)
      get :front
      expect(response).to redirect_to videos_path
    end
  end

  describe "GET new" do
    it "render new for unauthenticated user" do
      get :new
      expect(response).to render_template :new
    end
    it "redirect to videos path for authenticated user" do
      session[:user_id] = Fabricate(:user)
      get :new
      expect(response).to redirect_to videos_path
    end
  end

  describe "POST create" do
    context "both email and password are right" do
      let(:user)  { Fabricate(:user) }
      before do
        post :create, email: user.email, password: user.password
      end

      it "user can sign in" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirect to vidoes page" do
        expect(response).to redirect_to videos_path
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "email or password is wrong" do
      let(:user)  { Fabricate(:user) }
      before do
        post :create, email: user.email, password: user.password.concat("passowrd")
      end
      it "user cannot sign in" do
        expect(session[:user_id]).to be nil
      end

      it "render the new template" do
        expect(response).to render_template :new
      end

      it "sets the error message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "POST destroy" do
    let(:user)  { Fabricate(:user) }
    before do
      session[:user_id] = user.id
      post :destroy, user: user.id
    end

    it "redirect to front page" do
      expect(response).to redirect_to sign_in_path
    end

    it "clear the session" do
      expect(session[:user_id]).to be nil
    end

    it "sets the notice" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end
