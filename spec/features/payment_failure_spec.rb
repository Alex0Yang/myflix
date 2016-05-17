require 'spec_helper'

feature "payment failures" do
  scenario "user can sign in if payment success" do
    alice = Fabricate(:user, full_name: "Alice Doe", email: "test@test.com")
    Fabricate(:payment, user: alice, reference_id: "stripe_uyihihg", status: "succeeded")
    sign_in(alice)
    page.should have_content("Alice Doe")
  end

  scenario "user cannot sign in if payment failure" do
    alice = Fabricate(:user, full_name: "Alice Doe", email: "test@test.com")
    Fabricate(:payment, user: alice, reference_id: "stripe_uyihihg", status: "failed")
    sign_in(alice)
    page.should_not have_content("Alice Doe")
  end
end
