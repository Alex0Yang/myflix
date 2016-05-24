require 'spec_helper'

feature "Sign in" do
  let(:alice) { Fabricate(:user)}
  scenario "with correct password" do
    sign_in(alice)
    expect(page).to have_content alice.full_name
  end

  scenario "with correct password" do
    visit '/sign_in'
    fill_in "email", :with => "test@test.com"
    fill_in "password", :with => "assword"
    click_button "Sign in"
    expect(page).to have_content 'Incorrect'
  end

  scenario "user cannot sign in if unacitve" do
    alice = Fabricate(:user, active: false)
    sign_in(alice)
    page.should_not have_content(alice.full_name)
    page.should have_content("Your account has been suspended, please contact customer service.")
  end
end
