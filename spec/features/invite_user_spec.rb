require 'spec_helper'

feature "invite user" do
  scenario "invite user through email", { js: true, vcr: true } do
    alice = Fabricate(:user, full_name: "Alice", password: "password", email: "alice@example.com")
    sign_in alice
    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    friend_should_follow(alice)
    inviter_should_follow_friend(alice)

    clear_emails
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "lee"
    fill_in "Friend's Email Address", with: "lee@example.com"
    fill_in "Invitation Message", with: "hi"
    click_button "Send Invitation"
    visit sign_out_path
  end

  def friend_accepts_invitation
    open_email('lee@example.com')
    current_email.click_link "Accept this invitation"
    fill_in "user_password", with: "password"
    fill_in "user_full_name", with: "lee yang"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2016", from: "date_year"
    click_button "Sign Up"
  end

  def friend_signs_in
    fill_in "email", :with => "lee@example.com"
    fill_in "password", :with => "password"
    click_button "Sign in"
    expect(page).to have_content "Welcome, lee yang"
  end

  def friend_should_follow(alice)
    click_link "People"
    expect(page).to have_content alice.full_name
    visit sign_out_path
  end

  def inviter_should_follow_friend(alice)
    sign_in alice
    visit people_path
    expect(page).to have_content "lee yang"
  end
end
