require 'spec_helper'

describe "Create payment on successful charge", vcr: true do
  let(:charge_succeeded) { JSON.parse File.read("spec/fixtures/evt_charge_succeeded.json") }
  let!(:alice) { Fabricate(:user, stripe_id: "cus_8RmU9uUsmCqR1N") }

  it "create a new payments" do
    post "/stripe-hook", charge_succeeded
    expect(Payment.count).to eq(1)
  end

  it "create a new payments associated with user" do
    post "/stripe-hook", charge_succeeded
    expect(Payment.last.user).to eq(alice)
  end

  it "create a new payments with amount" do
    post "/stripe-hook", charge_succeeded
    expect(Payment.last.amount).to eq(999)
  end

  it "create a new payments with reference_id" do
    post "/stripe-hook", charge_succeeded
    expect(Payment.last.reference_id).to eq("ch_18AsvnEDK3tRuRHOjWXnYjVa")
  end

  it "create a new payments with currency" do
    post "/stripe-hook", charge_succeeded
    expect(Payment.last.currency).to eq("usd")
  end
end
