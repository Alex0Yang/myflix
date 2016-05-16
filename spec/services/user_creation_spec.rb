require 'spec_helper'

describe UserCreation do
  describe "#signup" do
    after { ActionMailer::Base.deliveries.clear }

    context "user's input is valid and valid card" do
      let!(:user) { Fabricate.build(:user) }

      before do
        charge = double(:charge, successful?: true, stripe_id: "stripe_id")
        StripeWrapper::Customer.should_receive(:create).and_return(charge)
      end

      it "delete the invited token" do
        alice = Fabricate(:user)
        bob = Fabricate.build(:user)
        invitation = Fabricate(:invitation, inviter: alice, friend_email: bob[:email])
        UserCreation.new(bob).signup(invite_token: invitation.invite_token, stripe_token: "123")
        expect(Invitation.last.invite_token).to eq(nil)
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        bob = Fabricate.build(:user)
        invitation = Fabricate(:invitation, inviter: alice, friend_email: bob[:email])
        UserCreation.new(bob).signup(invite_token: invitation.invite_token, stripe_token: "123")
        new_user = User.find_by email: bob[:email]
        expect(alice.follows?(new_user)).to be_truthy
      end

      it "makes the inviter follow the inviter" do
        alice = Fabricate(:user)
        bob = Fabricate.build(:user)
        invitation = Fabricate(:invitation, inviter: alice, friend_email: bob[:email])
        UserCreation.new(bob).signup(invite_token: invitation.invite_token, stripe_token: "123")
        new_user = User.find_by email: bob[:email]
        expect(alice.follows?(new_user)).to be_truthy
      end

      it "user registers successfully" do
        UserCreation.new(user).signup(stripe_token: "123")
        expect(User.find_by(email: user[:email]).full_name).to eq(user[:full_name])
      end

      it "store charge id" do
        UserCreation.new(user).signup(stripe_token: "123")
        expect(User.find_by(email: user[:email]).stripe_id).to eq("stripe_id")
      end

      it "sends out the email with valid inputs" do
        UserCreation.new(user).signup(stripe_token: "123")
        expect(ActionMailer::Base.deliveries.last.to).to eq([user[:email]])
      end

      it "sending out email containing the user's name with valid inputs" do
        UserCreation.new(user).signup(stripe_token: "123")
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(user[:full_name])
      end
    end

    context "valid personal info and declined card" do
      let!(:user) { Fabricate.build(:user) }

      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: "This card is declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(charge)
        UserCreation.new(user).signup(stripe_token: "123")
        expect(User.count).to eq(0)
      end

      it "does not send out email with declined credit card" do
        charge = double(:charge, successful?: false, error_message: "This card is declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(charge)
        UserCreation.new(user).signup(stripe_token: "123")
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "user's input in invalid" do

      it "cannot registers" do
        UserCreation.new(User.new(email: "test@test.com")).signup(stripe_token: "123")
        expect(User.find_by full_name: "some").to be nil
      end

      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
        UserCreation.new(User.new(email: "test@test.com")).signup(stripe_token: "123")
      end

      it "does not send out email with invalid inputs" do
        UserCreation.new(User.new(email: "test@test.com")).signup(stripe_token: "123")
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
