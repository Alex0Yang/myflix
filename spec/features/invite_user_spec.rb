require 'spec_helper'

feature "invite user" do
  scenario "invite user through email" do
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
    fill_in "invitation_friend_name", with: "lee"
    fill_in "invitation_friend_email", with: "lee@example.com"
    fill_in "invitation_message", with: "hi"
    click_button "Send Invitation"
    click_link "Sign Out"
  end

  def friend_accepts_invitation
    open_email('lee@example.com')
    current_email.click_link "Accept this invitation"
    expect(page).to have_content "Register"
    expect(find('input[id="user_email"]').value).to eq("lee@example.com")
    fill_in "user_password", with: "password"
    fill_in "user_full_name", with: "lee yang"
    click_button "Sign Up"
  end

  def friend_signs_in
    visit sign_in_path
    fill_in "email", :with => "lee@example.com"
    fill_in "password", :with => "password"
    click_button "Sign in"
    expect(page).to have_content "Welcome, lee yang"
  end

  def friend_should_follow(alice)
    visit people_path
    expect(page).to have_content alice.full_name
    click_link "Sign Out"
  end

  def inviter_should_follow_friend(alice)
    sign_in alice
    visit people_path
    expect(page).to have_content "lee yang"
  end
end
