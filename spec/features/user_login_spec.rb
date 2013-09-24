require 'spec_helper'

feature "logging in" do
  let(:user) { User.create(email: 'luke@stuff.com', password: 'password', full_name: 'Luke Tower') }


  scenario "logging in with correct credentials" do
    visit "/login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Sign In"
    expect(page).to have_content("enjoy")
  end
end

feature "logging in and adding a video to my queue page" do
  let(:user) { User.create(email: 'luke@stuff.com', password: 'password', full_name: 'Luke Tower') }


  scenario "logging in with correct credentials" do
    visit "/login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Sign In"
    expect(page).to have_content("enjoy")
    page.find(:xpath, '//img[@src="/tmp/south_park.jpg"]').click  # This is where I go wrong.
    expect(page).to have_content("Add to My Queue")
    click_button "Add to My Queue"
    expect(page).to have_content("You've added South Park to your queue.")
    click_link "South Park"
    expect(page).to have_no_content("Add to My Queue")
  end
end