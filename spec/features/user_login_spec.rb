require 'spec_helper'

feature "My Queue page" do
  given(:bob) { User.create(email: 'bob@stuff.com', password: 'password', full_name: 'Bob Smith') }
  given(:category) { Category.create(name: "Horror") }
  given(:video) { Fabricate(:video) }

  background do
    visit "/login"
    fill_in :email, with: bob.email
    fill_in :password, with: bob.password
    click_button "Sign In"
    video.categories << category
    video.user_reviews << UserReview.create(rating: 3, body: 'Kinda good', video_id: video.id, user_id: bob.id)
  end

  scenario "logging in with correct credentials" do
    page.should have_content("enjoy")
  end

  scenario "adding a video to my queue page" do
    add_video_to_queue(video)
    page.should have_content("You've added #{video.title} to your queue.")
  end

  scenario "try to add a previously added video to the queue" do
    add_video_to_queue(video)
    click_on "video_#{video.id}"
    click_on "Add to My Queue"
    page.should have_content("This video is already in your queue.")
  end

  scenario "add more videos to queue and reorder them" do
    Video.all.each { |video| add_video_to_queue(video) }
    visit queue_item_path

  end
end