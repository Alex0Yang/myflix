require 'spec_helper'

describe StripeWrapper::Charge do
  let(:token) do
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 9,
        :exp_year => 2017,
        :cvc => "314"
      },
    )
  end

  context "valid card", :vcr do
    let(:card_number) { "4242424242424242" }

    it "charges the card sucessfully" do
      charge = StripeWrapper::Charge.create(
        source: token,
        amount: 888,
        description: "a vaild charge"
      )

      charge.should be_successful
    end
  end

  context "invalid card", :vcr do
    let(:card_number) { "4000000000000002" }
    it "does not charge the card successfully" do
      charge = StripeWrapper::Charge.create(
        source: token,
        amount: 888,
        description: "a invalid charge"
      )
      charge.should_not be_successful
    end

    it "contains an error message" do
      charge = StripeWrapper::Charge.create(
        source: token,
        amount: 888,
        description: "rspec"
      )
      expect(charge.error_message).to be_present
    end
  end
end

describe StripeWrapper::Customer do
  let(:token) do
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 9,
        :exp_year => 2017,
        :cvc => "314"
      },
    )
  end

  context "valid card", :vcr do
    let(:card_number) { "4242424242424242" }

    it "subscribing a customer to a plan sucessfully" do
      charge = StripeWrapper::Customer.create(
        source: token,
        plan: "gold",
        email: "test@example.com",
        description: "a vaild charge"
      )

      charge.should be_successful
    end

    it "get cumstomer's id" do
      charge = StripeWrapper::Customer.create(
        source: token,
        plan: "gold",
        email: "test@example.com",
        description: "a vaild charge"
      )

      expect(charge.response.id).to be_present
    end
  end

  context "invalid card", :vcr do
    let(:card_number) { "4000000000000002" }
    it "does not subscribing a customer to a plan sucessfully" do
      charge = StripeWrapper::Customer.create(
        source: token,
        plan: "gold",
        email: "test@example.com",
        description: "a invalid charge"
      )
      charge.should_not be_successful
    end

    it "contains an error message" do
      charge = StripeWrapper::Customer.create(
        source: token,
        plan: "gold",
        email: "test@example.com",
        description: "rspec"
      )
      expect(charge.error_message).to be_present
    end
  end
end
