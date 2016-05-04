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
    context "invite user" do
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate.attributes_for(:user) }
      let!(:invitation) { Fabricate(:invitation, inviter: alice, friend_email: bob[:email]) }

      before { post :create, user: bob, invite_token: invitation.invite_token }

      it "delete the invited token" do
        expect(Invitation.last.invite_token).to eq(nil)
      end

      it "set @invite_token" do
        expect(assigns(:invite_token)).to eq(invitation.invite_token)
      end

      it "makes the user follow the inviter" do
        new_user = User.find_by email: bob[:email]
        expect(alice.follows?(new_user)).to be_truthy
      end

      it "makes the inviter follow the inviter" do
        new_user = User.find_by email: bob[:email]
        expect(alice.follows?(new_user)).to be_truthy
      end
    end

    context "user's input is valid" do
      let!(:user) { Fabricate.attributes_for(:user) }

      context "credit card is valid" do
        before do
          charge = double(:charge, successful?: true)
          StripeWrapper::Charge.should_receive(:create).and_return(charge)
          post :create, user: user, stripeToken: '123456'
        end

        it "user registers successfully" do
          expect(User.find_by(email: user[:email]).full_name).to eq(user[:full_name])
        end

        it "redirect to sign in page" do
          expect(response).to redirect_to sign_in_path
        end
      end

      context "credit card is invalid" do
        before do
          charge = double(:charge, successful?: false, error_message: "This card is declined.")
          StripeWrapper::Charge.should_receive(:create).and_return(charge)
          post :create, user: user, stripeToken: '123456'
        end

        it "user registers unsuccessfully" do
          expect(User.count).to eq(0)
        end

        it "redirect new page" do
          should render_template('new')
        end

        it "show notice" do
          should set_flash[:error]
        end
      end
    end

    context "email sending" do
      let!(:user) { Fabricate.attributes_for(:user) }

      it "sends out the email with valid inputs" do
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: user, stripeToken: '123456'
        expect(ActionMailer::Base.deliveries.last.to).to eq([user[:email]])
      end

      it "sending out email containing the user's name with valid inputs" do
        charge = double(:charge, successful?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: user, stripeToken: '123456'
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(user[:full_name])
      end

      it "does not send out email with invalid inputs" do
        post :create, user: { full_name: "some" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not send out email with invalid credit card" do
        charge = double(:charge, successful?: false, error_message: "This card is declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: user, stripeToken: '123456'
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "user's input in invalid" do
      before do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: { full_name: "some" }, stripeToken: '123456'
      end

      it "cannot registers" do
        expect(User.find_by full_name: "some").to be nil
      end

      it "render new template" do
        expect(response).to render_template :new
      end

      it "set @user" do
        expect(assigns(:user)).to be_kind_of(User)
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
