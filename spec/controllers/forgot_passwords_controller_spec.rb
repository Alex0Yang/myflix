require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }

    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ""
        expect(response).to redirect_to forgot_password_path
      end

      it "show an error message" do
        post :create, email: ""
        should set_flash[:danger]
      end
    end

    context "with existing email" do
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

      it "redirect to forgot password confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end
    end

    context "with non-existing email" do
      before { post :create, email: "non@example.com" }

      it "have a notice" do
        should set_flash[:danger]
      end

      it "dose not send email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "redirect to forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end
    end

  end
end
