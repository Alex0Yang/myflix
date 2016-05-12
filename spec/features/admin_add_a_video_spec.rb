require 'spec_helper'

feature "Admin adds new video" do
  scenario "Admin successfully adds add a new video" do
    sign_in_admin
    category = Fabricate(:category)

    visit new_admin_video_path
    fill_in "Title", with: "Cards"
    select category.name, from: "Category"
    fill_in "Description", with: "good show!"
    attach_file 'Large Cover', "public/tmp/monk_large.jpg"
    attach_file 'Small Cover', "public/tmp/monk.jpg"
    fill_in "Video URL", with: "http://test.com/test.mp4"
    click_button "Add Video"

    click_link "Sign Out"
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/video/large_cover/#{Video.last.id}/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://test.com/test.mp4']")
  end
end
