require 'spec_helper'

feature "adding a new video" do
  scenario "admin logs in and adds a video" do
    admin = Fabricate(:admin)
    bob = Fabricate(:user)
    category = Fabricate(:category)
    visit root_path
    click_link 'Sign In'
    login(admin)
    visit new_admin_video_path
    fill_in 'Title', with: 'Video Title'
    select category.name, from: 'Categories'
    fill_in 'Description', with: 'This movie is so good.'
    attach_file 'Large Cover', 'spec/support/uploads/monk_large.jpg'
    attach_file 'Small Cover', 'spec/support/uploads/monk.jpg'
    fill_in "Video URL", with: 'http://www.monk.com/monk.mp4'
    click_on 'Add Video'
    click_link "Welcome, #{admin.full_name}"
    click_link 'Sign Out'
    click_link 'Sign In'
    login(bob)
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.monk.com/monk.mp4']")
  end
end