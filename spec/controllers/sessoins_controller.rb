require 'spec_helper'

describe SessionsController do
  describe "GET front" do
    it "redirect to videos path for authticated user" do
      session[:user_id] = Fabricate(:user)
      get :front
      expect(response).to redirect_to videos_path
    end
  end

  describe "GET new" do
    it "redirect to videos path for authticated user" do
      session[:user_id] = Fabricate(:user)
      get :new
      expect(response).to redirect_to videos_path
    end
  end

  describe "POST create" do
    context "both email and password are right" do
      let(:user)  { Fabricate(:user) }

      it "user can sign in" do
        post :create, email: user.email, password: user.password
        expect(session[:user_id]).to eq(user.id)
      end
      it "redirect to vidoes page" do
        post :create, email: user.email, password: user.password
        expect(response).to redirect_to videos_path
      end
    end

    context "email or password is wrong" do
      let(:user)  { Fabricate(:user) }
      it "user cannot sign in" do
        post :create, email: user.email, password: user.password.concat("passowrd")
        expect(session[:user_id]).to be nil
      end

      it "render the new template" do
        post :create, email: user.email, password: user.password.concat("passowrd")
        expect(response).to render_template :new
      end
    end
  end

  describe "POST destroy" do
    let(:user)  { Fabricate(:user) }
    before { session[:user_id] = user.id }

    it "redirect to front page" do
      post :destroy, user: user.id
      expect(response).to redirect_to sign_in_path
    end

    it "no authenticated user" do
      post :destroy, user: user.id
      expect(session[:user_id]).to be nil
    end
  end
end
