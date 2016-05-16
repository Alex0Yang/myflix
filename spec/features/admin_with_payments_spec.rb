require 'spec_helper'

feature "admin with payments" do
  background do
    alice = Fabricate(:user, full_name: "Alice Doe", email: "test@test.com")
    Fabricate(:payment, user: alice, reference_id: "stripe_uyihihg")
  end

  scenario "admin can see payments" do
    sign_in_admin
    visit admin_payments_path
    page.should have_content("stripe_uyihihg")
    page.should have_content("$9.99")
    page.should have_content("Alice Doe")
    page.should have_content("stripe_uyihihg")
  end
  scenario "user cannot see payments" do
    sign_in
    visit admin_payments_path
    page.should have_content("Only admin can visit this page.")
  end
end
