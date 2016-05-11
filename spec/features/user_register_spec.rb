require 'spec_helper'

feature "User registers", { js: true, vcr: true } do
  background do
    visit register_path
  end

  scenario "user register with valid input and valid credit card" do
    fill_in_valid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(page).to have_content "Sign in", wait: 20
    expect(page).to have_content "Thank you for registering with MyFLix. Please sign in now."
  end

  scenario "user register with valid input and declined credit card" do
    fill_in_valid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content "Your card was declined.", wait: 20
  end

  scenario "user register with valid input and invalid credit card" do
    fill_in_valid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(page).to have_content "The card number is not a valid credit card number.", wait: 20
  end

  scenario "user register with invalid input and valid credit card" do
    fill_in_invalid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(page).to have_content "Invalid user inforamtion, Please check the errors below.", wait: 20
  end

  scenario "user register with invalid input and invalid credit card" do
    fill_in_invalid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(page).to have_content "The card number is not a valid credit card number.", wait: 20
  end

  scenario "user register with invalid input and declined card" do
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content "Invalid user inforamtion, Please check the errors below.", wait: 20
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "lee@examle.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Lee"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "lee@examle.com"
    fill_in "Full Name", with: "Lee"
  end

  def fill_in_valid_card
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2016", from: "date_year"
  end

  def fill_in_invalid_card
    fill_in "Credit Card Number", with: "40002"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2016", from: "date_year"
  end

  def fill_in_declined_card
    fill_in "Credit Card Number", with: "4000000000000002"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2016", from: "date_year"
  end
end
