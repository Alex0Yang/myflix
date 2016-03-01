require 'spec_helper'

feature "my queue" do
  scenario "users adds and reorders videos in the queue" do
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    futurama = Fabricate(:video, title: "Futurama", category: comedies)
    sign_in
    find("a[href='/videos/#{monk.id}']").click
    page.should have_content(monk.title)

    click_link "+ My Queue"
    page.should have_content(monk.title)

    visit video_path(monk)
    page.should have_no_content("+ My Queue")

    visit videos_path
    find("a[href='/videos/#{south_park.id}']").click
    click_link "+ My Queue"

    visit videos_path
    find("a[href='/videos/#{futurama.id}']").click
    click_link "+ My Queue"

    visit my_queue_path
    find("input[data-video-id='#{monk.id}']").set(4)
    find("input[data-video-id='#{south_park.id}']").set(3)
    find("input[data-video-id='#{futurama.id}']").set(2)

    click_button "Update Instant Queue"
    expect(find("input[data-video-id='#{monk.id}']").value).to eq("3")
    expect(find("input[data-video-id='#{south_park.id}']").value).to eq("2")
    expect(find("input[data-video-id='#{futurama.id}']").value).to eq("1")

  end

end
