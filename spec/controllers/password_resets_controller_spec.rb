require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    let(:alice) { Fabricate(:user, reset_token: "123456") }

    context "reset token is valid" do
      it "set @reset_token" do
        get :show, reset_token: alice.reset_token
        expect(assigns(:reset_token)).to eq(alice.reset_token)
      end
    end

    context "reset token is invalid" do
      it "redirect to the expired token page" do
        get :show, reset_token: alice.reset_token + "token"
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe "POST create" do
    context "valid reset token" do
      let(:alice) { Fabricate(:user, reset_token: "123456") }
      before { post :create, user: { reset_token: alice.reset_token, password: "new_password" } }

      it "update user's password" do
        expect(alice.reload.authenticate("new_password")).to be_truthy
      end

      it "remove reset token of user" do
        expect(User.last.reset_token).to eq(nil)
      end

      it "redirect to sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets the flash success message" do
        should set_flash[:success]
      end
    end

    context "invalid reset token" do
      it "redirect to forgot password page" do
        post :create, user: { reset_token: "reset_token", password: "new_password" }
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
