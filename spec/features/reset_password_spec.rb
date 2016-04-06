require 'spec_helper'

feature "reset password" do
  scenario "reset password through email" do
    clear_emails
    alice = Fabricate(:user,password: "password", email: "alice@example.com")

    visit forgot_password_path
    fill_in "email", with: "alice@example.com"
    click_button 'Send Email'
    expect(page).to have_content 'send an email'

    open_email('alice@example.com')
    current_email.click_link 'reset password'

    expect(page).to have_content 'Reset Your Password'
    fill_in "user_password", with: "new_password"
    click_button 'Reset Password'

    expect(page).to have_content 'Sign in'
    fill_in "email", with: "alice@example.com"
    fill_in "password", with: "new_password"
    click_button 'Sign in'

    expect(page).to have_content alice.full_name
  end
end
