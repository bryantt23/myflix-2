require 'spec_helper'

feature "People I Follow page" do

  scenario "add and remove from follow page" do
    bob = Fabricate(:user)
    joe = Fabricate(:user)
    comedies = Fabricate(:category, name: 'Comedies')
    video = Fabricate(:video, user_reviews: [Fabricate(:user_review, user_id: joe.id)], categories: [comedies])

    login(bob)
    visit root_path
    page.should have_content("Comedies")

    click_on "video_#{video.id}"
    page.should have_content("#{joe.full_name}")

    click_on "#{joe.full_name}"
    page.should have_button("Follow")

    click_on "Follow"
    page.should have_content("People I Follow")

    click_on "People"
    page.should have_content("#{joe.full_name}")

    within(:xpath, "//tr[contains(.,'#{joe.full_name}')]") do
      find("a[href='/follows/#{joe.id}']").click
    end
    page.should have_no_content("#{joe.full_name}")
  end
end