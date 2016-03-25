require 'spec_helper'

feature "my queue" do
  scenario "users adds and reorders videos in the queue" do

    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    futurama = Fabricate(:video, title: "Futurama", category: comedies)

    sign_in

    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)

    visit video_path(monk)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(south_park)
    add_video_to_queue(futurama)

    visit my_queue_path
    set_video_position(monk, 4)
    set_video_position(south_park, 3)
    set_video_position(futurama, 2)

    update_queue

    expect_video_position(monk, 3)
    expect_video_position(south_park, 2)
    expect_video_position(futurama, 1)

  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def expect_video_to_be_in_queue(video)
    page.should have_content(video.title)
  end

  def expect_link_not_to_be_seen(link_text)
    page.should have_no_content(link_text)
  end

  def add_video_to_queue(video)
    visit videos_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end

end
