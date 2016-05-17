require 'spec_helper'

describe "Deactivate user on failed charge", :vcr do
  let!(:charge_failed) { JSON.parse File.read("spec/fixtures/evt_charge_failed.json") }
  let!(:alice) { Fabricate(:user, stripe_id: "cus_8SeRlFDj01A3r9") }

  it "deactivates a user with the web hook data form stripe for charge failed" do
    post "/stripe-hook", charge_failed
    expect(alice.reload).not_to be_active
  end
end
