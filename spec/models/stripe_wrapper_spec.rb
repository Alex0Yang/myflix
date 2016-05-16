require 'spec_helper'

describe StripeWrapper do
  let(:valid_card_number) { "4242424242424242" }
  let(:decline_card_number) { "4000000000000002" }

  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => valid_card_number,
        :exp_month => 9,
        :exp_year => 2017,
        :cvc => "314"
      },
    )
  end

  let(:decline_card_token) do
    Stripe::Token.create(
      :card => {
        :number => decline_card_number,
        :exp_month => 9,
        :exp_year => 2017,
        :cvc => "314"
      },
    )
  end
  describe StripeWrapper::Charge do
    describe ".create" do
      context "valid card", :vcr do
        it "charges the card sucessfully" do
          charge = StripeWrapper::Charge.create(
            source: valid_token,
            amount: 888,
            description: "a vaild charge"
          )

          charge.should be_successful
        end
      end

      context "invalid card", :vcr do
        it "does not charge the card successfully" do
          charge = StripeWrapper::Charge.create(
            source: decline_card_token,
            amount: 888,
            description: "a invalid charge"
          )
          charge.should_not be_successful
        end

        it "contains an error message" do
          charge = StripeWrapper::Charge.create(
            source: decline_card_token,
            amount: 888,
            description: "rspec"
          )
          expect(charge.error_message).to be_present
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      let(:alice) { Fabricate(:user, email: "test@example.com" ) }

      context "valid card", :vcr do

        it "subscribing a customer to a plan sucessfully" do
          charge = StripeWrapper::Customer.create(
            user: alice,
            source: valid_token,
            description: "a vaild charge"
          )

          charge.should be_successful
        end

        it "return stripe id", :vcr do
          charge = StripeWrapper::Customer.create(
            user: alice,
            source: valid_token,
            description: "a vaild charge"
          )

          expect(charge.stripe_id).to be_present
        end
      end

      context "decline card", :vcr do
        let(:card_number) { "4000000000000002" }
        it "does not subscribing a customer to a plan sucessfully" do
          charge = StripeWrapper::Customer.create(
            user: alice,
            source: decline_card_token,
            description: "a invalid charge"
          )
          charge.should_not be_successful
        end

        it "contains an error message" do
          charge = StripeWrapper::Customer.create(
            user: alice,
            source: decline_card_token,
            description: "rspec"
          )
          expect(charge.error_message).to be_present
        end
      end
    end
  end
end
