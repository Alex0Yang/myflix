require 'spec_helper'

feature  "social netwroking in flix"  do
  scenario "user can follow another user" do
    monk = Fabricate(:video, title: "monk")
    alice = Fabricate(:user)
    bob = Fabricate(:user)
    Fabricate(:comment, user: alice, video: monk)

    sign_in bob
    click_on_video_on_home_page(monk)

    click_link alice.full_name
    click_link "Follow"

    expect(page).to have_content "People I Follow"
    expect(page).to have_content alice.full_name

    unfollow(alice)
    expect(page).not_to have_content alice.full_name
  end

  def unfollow(user)
    find("a[href='/relationships/#{Relationship.find_by(leader_id: user.id).id}']").click
  end
end
