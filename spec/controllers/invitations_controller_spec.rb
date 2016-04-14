require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "set @invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_kind_of(Invitation)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context "valid input" do
      let(:alice) { Fabricate(:user) }
      let (:invitation) { Fabricate.attributes_for(:invitation, user: alice) }

      before do
        set_current_user alice
        post :create, invitation: invitation
      end

      after { ActionMailer::Base.deliveries.clear }

      it "redirects to the invitation" do
        expect(response).to redirect_to new_invitation_path
      end

      it "create new invitation associated with current_user" do
        expect(current_user.invitations.map(&:friend_email)).to eq([invitation[:friend_email]])
      end

      it "generate invite token" do
        expect(Invitation.last.invite_token).to be_present
      end

      it "send email to the friend" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([invitation[:friend_email]])
      end

      it "invitation email has register link with invite token" do
        expect(ActionMailer::Base.deliveries.last.body).to include(Invitation.last.invite_token)
      end

      it "show the notice" do
        should set_flash[:info]
      end
    end

    context "invalid input" do
      before do
        set_current_user
        post :create, invitation: { friend_name: "alice" }
      end

      it "set @invitation" do
        expect(assigns(:invitation)).to be_kind_of(Invitation)
      end

      it "does not create an invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "render new page" do
        should render_template('new')
      end

      it "show the notice" do
        should set_flash.now[:danger]
      end
    end
  end
end
