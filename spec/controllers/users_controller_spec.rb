require 'spec_helper'

describe UsersController do
  describe "GET new_with_invite_token" do
    let(:invitation) { Fabricate(:invitation, friend_email: "test@test.com") }

    it "set @user with friend's email" do
      get :new_with_invitation_token, invite_token: invitation.invite_token
      expect(assigns(:user).email).to eq("test@test.com")
    end

    it "set @invite_token" do
      get :new_with_invitation_token, invite_token: invitation.invite_token
      expect(assigns(:invite_token)).to eq(invitation.invite_token)
    end

    it "renders the :new view template" do
      get :new_with_invitation_token, invite_token: invitation.invite_token
      expect(response).to render_template :new
    end

    it "show expired token page if invalid token" do
      get :new_with_invitation_token, invite_token: invitation.invite_token + "213"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "GET new" do
    it "set the @user" do
      get :new
      expect(assigns(:user)).to be_kind_of(User)
    end
  end

  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }

    context "successful user sign up" do
      let!(:user) { Fabricate.attributes_for(:user) }

      before do
        result = double(:result, successful?: true)
        UserCreation.any_instance.should_receive(:signup).and_return(result)
        post :create, user: user, stripeToken: '123456'
      end

      it "redirect to sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "show notice" do
        should set_flash[:notice]
      end
    end

    context "faild user sign up" do
      let!(:user) { Fabricate.attributes_for(:user) }
      before do
        result = double(:result, successful?: false, error_message: "This card is declined.")
        UserCreation.any_instance.should_receive(:signup).and_return(result)
        post :create, user: user, stripeToken: '123456'
      end

      it "render new page" do
        should render_template('new')
      end

      it "show notice" do
        should set_flash[:danger]
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 3 }
    end

    it "set the @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end
