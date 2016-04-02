require 'spec_helper'

describe PasswordsController do
  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }

    context "email existed" do
      let(:alice) { Fabricate(:user) }
      before { post :create, email: alice.email }

      it "send email" do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([alice.email])
      end

      it "reset email has reset link" do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(alice.reset_token)
      end

      it "user has a reset token in databse" do
        expect(alice.reload.reset_token).to be_truthy
      end

      it "redirect to root_path" do
        expect(response).to redirect_to root_path
      end

      it "have a notice" do
        should set_flash[:info]
      end
    end

    context "email is not existed" do
      it "have a notice" do
        post :create, email: ""
        should set_flash.now[:danger]
      end

      it "dose not send email" do
        post :create, email: ""
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "render forgot password page" do
        post :create, email: ""
        expect(response).to render_template :new
      end
    end

  end

  describe "GET show" do
    context "reset token is valid" do
      it "set @reset_token" do
        alice = Fabricate(:user, reset_token: SecureRandom.urlsafe_base64)
        get :show, reset_token: alice.reset_token
        expect(assigns(:reset_token)).to eq(alice.reset_token)
      end
    end

    context "reset token is invalid" do
      it "redirect to forgot password page" do
        alice = Fabricate(:user, reset_token: SecureRandom.urlsafe_base64)
        get :show, reset_token: alice.reset_token + "token"
        expect(response).to redirect_to forgot_password_path
      end

      it "show the notice" do
        alice = Fabricate(:user, reset_token: SecureRandom.urlsafe_base64)
        get :show, reset_token: alice.reset_token + "token"
        should set_flash[:danger]
      end
    end
  end

  describe "POST update" do
    context "valid reset token" do
      it "update user's password" do
        alice = Fabricate(:user, reset_token: SecureRandom.urlsafe_base64)
        post :update, user: { reset_token: alice.reset_token, password: "new_password" }
        expect(alice.reload.authenticate("new_password")).to be_truthy
      end

      it "remove reset token of user" do
        alice = Fabricate(:user, reset_token: SecureRandom.urlsafe_base64)
        post :update, user: { reset_token: alice.reset_token, password: "new_password" }
        expect(User.last.reset_token).to eq(nil)
      end

      it "redirect to sign in page" do
        alice = Fabricate(:user, reset_token: SecureRandom.urlsafe_base64)
        post :update, user: { reset_token: alice.reset_token, password: "new_password" }
        expect(response).to redirect_to sign_in_path
      end
    end
    context "invalid reset token" do
      it "redirect to forgot password page" do
        post :update, user: { reset_token: "reset_token", password: "new_password" }
        expect(response).to redirect_to forgot_password_path
      end
    end
  end
end
